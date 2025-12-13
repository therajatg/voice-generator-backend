class VoiceGeneration < ApplicationRecord
    #validations
    validates :text, presence: true, length: { minimum: 1, maximum: 5000 }
    validates :status, presence: true, inclusion: { in: %w[pending processing completed failed] }

    #scopes
    
end
