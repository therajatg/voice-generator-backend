require 'rails-helper'

RSpec.describe 'Api::VoiceGenerations', type: :request do
    describe 'POST /api/voice_generations' do
        let(:valid_params) do
            {voice_generation: {text: 'Hello, this is a test.' }}
        end

        it 'creates a voice generation with valid params' do
            expect {
                post '/api/voice_generations', params: valid_params, as: :json
            }.to change(VoiceGeneration, :count).by(1)
        end

        it 'returns 201 created status' do
            post '/api/voice_generations', params: valid_params, as: :json
            expect(response).to have_http_status(:created)
        end

        it 'returns the created voice generation' do
            post '/api/voice_generations', params: valid_params, as: :json
            json = JSON.parse(response.body)

            expect(json['id']).to be_present
            expect(json['status']).to eq('pending')
            expect(json['text']).to eq('Hello, this is a test.')
        end

        it 'enqueues a background job' do
            expect {
                post '/api/voice_generations', params: valid_params, as: :json
            }.to have_enqueued_job(VoiceGenerationJob)
        end

        it 'returns 422 with errors when text is empty' do
            post '/api/voice_generations', params: { voice_generation: { text: '' } }, as: :json
  
            expect(response).to have_http_status(:unprocessable_entity)
  
            json = JSON.parse(response.body)
            expect(json['errors']).to be_present
        end

        it 'does not create record with invalid params' do
            expect {
                post '/api/voice_generations', params: { voice_generation: { text: '' } }, as: :json
            }.not_to change(VoiceGeneration, :count)
        end
    end

    
    describe 'GET /api/voice_generations/:id' do
        let!(:voice_generation) do
            VoiceGeneration.create!(
            text: 'Test',
            status: 'completed',
            audio_url: 'https://example.com/audio.mp3'
        )
        end

        it 'returns the voice generation' do
            get "/api/voice_generations/#{voice_generation.id}", as: :json
            expect(response).to have_http_status(:ok)
        end

        it 'returns correct data' do
            get "/api/voice_generations/#{voice_generation.id}", as: :json
            json = JSON.parse(response.body)
      
            expect(json['id']).to eq(voice_generation.id)
            expect(json['text']).to eq('Test')
            expect(json['status']).to eq('completed')
            expect(json['audio_url']).to eq('https://example.com/audio.mp3')
        end

        it 'returns 404 for non-existent id' do
            get '/api/voice_generations/99999', as: :json
            expect(response).to have_http_status(:not_found)
        end
    end


    describe 'GET /api/voice_generations' do
        it 'returns empty array when no records' do
            get '/api/voice_generations', as: :json
            json = JSON.parse(response.body)
      
            expect(json['voice_generations']).to eq([])
        end

        it 'returns all voice generations' do
            VoiceGeneration.create!(text: 'Test 1', status: 'completed')
            VoiceGeneration.create!(text: 'Test 2', status: 'pending')
      
            get '/api/voice_generations', as: :json
            json = JSON.parse(response.body)
      
            expect(json['voice_generations'].length).to eq(2)
        end

        it 'returns voice generations in reverse chronological order' do
            first = VoiceGeneration.create!(text: 'First', status: 'completed')
            second = VoiceGeneration.create!(text: 'Second', status: 'completed')
      
            get '/api/voice_generations', as: :json
            json = JSON.parse(response.body)
      
            expect(json['voice_generations'][0]['id']).to eq(second.id)
            expect(json['voice_generations'][1]['id']).to eq(first.id)
        end
    end
end



            

