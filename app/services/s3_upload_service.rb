require 'aws-sdk-s3'

class S3UploadService
    def initialize
        @s3_client = Aws::S3::Resource.new(
        region: ENV['AWS_REGION'],
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
        )
        @bucket_name = ENV['AWS_BUCKET']
    end

    def upload_audio(audio_data, filename)
        bucket = @s3_client.bucket(@bucket_name)
        object = bucket.object("audio/#{filename}")

        object.put(
            body: audio_data,
            acl: 'public-read',
            content_type: 'audio/mpeg'
        )

        object.public_url

    rescue Aws::S3::Errors::ServiceError => e
        Rails.logger.error "S3 Upload Error: #{e.message}"
        raise "Failed to upload to S3: #{e.message}"
    end

    def delete_audio(audio_url)
        return unless audio_url.present?

        uri = URI.parse(audio_url)
        key = uri.path[1..-1]

        bucket = @s3_client.bucket(@bucket_name)
        object = bucket.object(key)
        object.delete
    rescue => e
        Rails.logger.error "S3 Delete Error: #{e.message}"
    end
end




