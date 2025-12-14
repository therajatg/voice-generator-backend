class Api::VoiceGenerationsController < ApplicationController
    # Skip CSRF token verification for API requests
    skip_before_action :verify_authenticity_token

    def create
        voice_generation = VoiceGeneration.new(voice_generation_params)

        # true if the record was saved successfully (passed validations) and false if validations failed or save failed
        if voice_generation.save
            VoiceGenerationJob.perform_later(voice_generation.id)

            render json: { id: voice_generation.id,
                status: voice_generation.status,
                text: voice_generation.text,
                created_at: voice_generation.created_at,
                message: 'Voice generation started successfully'}, status: :created
        else
            render json: {
            errors: voice_generation.errors.full_messages
          }, status: :unprocessable_entity
        end
    end

    def show
        voice_generation = VoiceGeneration.find(params[:id])

        render json: {
            id: voice_generation.id,
            text: voice_generation.text,
            status: voice_generation.status,
            audio_url: voice_generation.audio_url,
            error_message: voice_generation.error_message,
            created_at: voice_generation.created_at,
            updated_at: voice_generation.updated_at
        }

    rescue ActiveRecord::RecordNotFound
        render json: {error: 'Voice generation not found'}, status: :not_found
    end

    def index
        voice_generations = VoiceGeneration.order(created_at: :desc).limit(50) 

        render json: {
            voice_generations: voice_generations.map do |vg| {
                id: vg.id,
                text: vg.text.truncate(100),
                status: vg.status,
                audio_url: vg.audio_url,
                created_at: vg.created_at
            }
        end
        }
    end

    private

    def voice_generation_params
        params.require(:voice_generation).permit(:text)
    end


end
