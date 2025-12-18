require 'rails_helper'

RSpec.describe VoiceGenerationJob, type: :job do
  let(:voice_generation) { VoiceGeneration.create!(text: 'Hello world', status: 'pending') }

  before do
    allow_any_instance_of(ElevenlabsService)
      .to receive(:text_to_speech)
      .and_return('fake_audio_data')
    
    allow_any_instance_of(S3UploadService)
      .to receive(:upload_audio)
      .and_return('https://example.com/audio.mp3')
  end

  it 'completes successfully and updates status' do
    VoiceGenerationJob.perform_now(voice_generation.id)
    
    voice_generation.reload
    expect(voice_generation.status).to eq('completed')
    expect(voice_generation.audio_url).to eq('https://example.com/audio.mp3')
  end

  it 'marks as failed on error' do
    allow_any_instance_of(ElevenlabsService)
      .to receive(:text_to_speech)
      .and_raise('API Error')
    
    expect { VoiceGenerationJob.perform_now(voice_generation.id) }.to raise_error
    
    voice_generation.reload
    expect(voice_generation.status).to eq('failed')
  end
end