class VoiceGenerationJob < ApplicationJob
  queue_as :default

  retry_on StandardError, wait: :exponentially_longer, attempts: 3

  def perform(voice_generation_id)
    voice_generation = VoiceGeneration.find(voice_generation_id)

    # Mark as processing
    voice_generation.update!(status: 'processing')

    # Generate audio
    elevenlabs_service = ElevenlabsService.new
    audio_data = elevenlabs_service.text_to_speech(voice_generation.text)

    #upload_to_s3
    filename = "voice_#{voice_generation.id}_#{Time.current.to_i}.mp3"
    s3Service = S3UploadService.new
    audio_url = s3Service.upload_audio(audio_data, filename)

    # Mark as completed
    voice_generation.update!(status: 'completed',
      audio_url: audio_url,
      error_message: nil)

      Rails.logger.info "Voice generation #{voice_generation_id} completed successfully"
    rescue => e
    Rails.logger.error "Voice generation #{voice_generation_id} failed: #{e.message}"
    voice_generation.update!(status: 'failed', error_message: error)
    raise e
  end
end
