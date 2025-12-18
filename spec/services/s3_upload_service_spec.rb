require 'rails_helper'

RSpec.describe S3UploadService do
  let(:service) { described_class.new }
  let(:mock_bucket) { instance_double(Aws::S3::Bucket) }
  let(:mock_object) { instance_double(Aws::S3::Object) }

  before do
    allow_any_instance_of(Aws::S3::Resource).to receive(:bucket).and_return(mock_bucket)
    allow(mock_bucket).to receive(:object).and_return(mock_object)
    allow(mock_object).to receive(:put)
    allow(mock_object).to receive(:public_url).and_return('https://s3.example.com/audio.mp3')
  end

  it 'uploads audio to S3' do
    expect(mock_object).to receive(:put)
    service.upload_audio('audio_data', 'test.mp3')
  end

  it 'returns public URL' do
    result = service.upload_audio('audio_data', 'test.mp3')
    expect(result).to eq('https://s3.example.com/audio.mp3')
  end

  it 'raises error on upload failure' do
    allow(mock_object).to receive(:put).and_raise(Aws::S3::Errors::ServiceError.new(nil, 'Error'))
    
    expect {
      service.upload_audio('audio_data', 'test.mp3')
    }.to raise_error(/Failed to upload/)
  end
end