class ElevenlabsService
    include HTTParty
    base_uri 'https://api.elevenlabs.io/v1'

    def initialize
        @api_key = ENV['ELEVENLABS_API_KEY']
        raise 'ELEVENLABS_API_KEY not set' if @api_key.blank?
    end

    def text_to_speech(text, voice_id: 'EXAVITQu4vr4xnSDxMaL')
        response = self.class.post("/text-to-speech/#{voice_id}", headers: headers, body: {
        text: text,
        model_id: 'eleven_monolingual_v1',
        voice_settings: {
          stability: 0.5,
          similarity_boost: 0.75
        }
      }.to_json)

      if response.success?
        # here response is an audio file, not JSON hence no need to get parsed_response
        response.body  
      else
        raise "ElevenLabs API Error: #{response.code} - #{response.message}"
      end
    end

    def get_voices
        response = self.class.get('/voices', headers: headers)

        if response.success?
            response.parsed_response
        else
            raise "ElevenLabs API Error: #{response.code} - #{response.message}"
        end
    end

    private

    def headers
        {
        'Accept' => 'audio/mpeg',
        'Content-Type' => 'application/json',
        'xi-api-key' => @api_key
        }
    end
end