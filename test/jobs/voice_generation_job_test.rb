require "test_helper"

class VoiceGenerationJobTest < ActiveJob::TestCase
  test "processes voice generation successfully" do
    voice_generation = voice_generations(:two)

    mock_elevenlabs = Minitest::Mock.new
    mock_elevenlabs.expect :text_to_speech, "fake_audio_data", [String]

    mock_upload = Minitest::Mock.new
    mock_upload.expect :upload_audio, "https://example.com/audio.mp3", [String, String]

    ElevenlabsService.stub :new, mock_elevenlabs do
      S3UploadService.stub :new, mock_upload do
        VoiceGenerationJob.perform_now(voice_generation.id) 
      end
    end

    voice_generation.reload
    assert_equal "completed", voice_generation.status
    assert_not_nil voice_generation.audio_url
  end

  test "marks as failed on error" do
    voice_generation = voice_generations(:two)
    
    mock_elevenlabs = Minitest::Mock.new
    mock_elevenlabs.expect :text_to_speech, ->(_) { raise "API Error" }, [String]

    ElevenlabsService.stub :new, mock_elevenlabs do
      assert_raises(RuntimeError) do
        VoiceGenerationJob.perform_now(voice_generation.id)
      end
    end

    voice_generation.reload
    assert_equal "failed", voice_generation.status
  end
end
