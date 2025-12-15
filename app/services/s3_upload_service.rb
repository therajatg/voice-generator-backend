require 'aws-sdk-s3'

class S3UploadService
  def initialize
    @s3_client = Aws::S3::Client.new(
      region: ENV['AWS_REGION'],
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    )
    @bucket_name = ENV['S3_BUCKET_NAME']
    
    raise 'AWS_BUCKET not set' if @bucket_name.blank?
  end

  def upload_audio(audio_data, filename)
    @s3_client.put_object(
      bucket: @bucket_name,
      key: "audio/#{filename}",
      body: audio_data,
      acl: 'public-read',
      content_type: 'audio/mpeg'
    )

    # Return public URL
    "https://#{@bucket_name}.s3.#{ENV['AWS_REGION']}.amazonaws.com/audio/#{filename}"
  rescue Aws::S3::Errors::ServiceError => e
    Rails.logger.error "S3 Upload Error: #{e.message}"
    raise "Failed to upload to S3: #{e.message}"
  end

  def delete_audio(audio_url)
    return unless audio_url.present?

    uri = URI.parse(audio_url)
    key = uri.path[1..-1]

    @s3_client.delete_object(
      bucket: @bucket_name,
      key: key
    )
  rescue => e
    Rails.logger.error "S3 Delete Error: #{e.message}"
  end
end
