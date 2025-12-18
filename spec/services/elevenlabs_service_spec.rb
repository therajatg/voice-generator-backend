require 'rails_helper'

RSpec.describe ElevenlabsService do
  let(:service) { described_class.new }

  before do
    stub_request(:post, /api.elevenlabs.io/)
      .to_return(status: 200, body: 'fake_audio', headers: {})
  end

  it 'calls ElevenLabs API' do
    service.text_to_speech('Hello')
    
    expect(WebMock).to have_requested(:post, /api.elevenlabs.io/)
  end

  it 'returns audio data' do
    result = service.text_to_speech('Hello')
    expect(result).to eq('fake_audio')
  end

  it 'raises error on API failure' do
    stub_request(:post, /api.elevenlabs.io/)
      .to_return(status: 500)
    
    expect {
      service.text_to_speech('Hello')
    }.to raise_error(/ElevenLabs API Error/)
  end
end