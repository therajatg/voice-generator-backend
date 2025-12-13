class VoiceGeneration < ApplicationRecord
    #validations
    validates :text, presence: true, length: { minimum: 1, maximum: 5000 }
    validates :status, presence: true, inclusion: { in: %w[pending processing completed failed] }    

#    # Scopes
#   scope :recent, -> { order(created_at: :desc) }
#   scope :completed, -> { where(status: 'completed') }
#   scope :failed, -> { where(status: 'failed') }
#   scope :pending, -> { where(status: 'pending') }

#   # Status helpers
#   def pending?
#     status == 'pending'
#   end

#   def processing?
#     status == 'processing'
#   end

#   def completed?
#     status == 'completed'
#   end

#   def failed?
#     status == 'failed'
#   end

#   # State transitions
#   def mark_as_processing!
#     update!(status: 'processing')
#   end

#   def mark_as_completed!(audio_url)
#     update!(
#       status: 'completed',
#       audio_url: audio_url,
#       error_message: nil
#     )
#   end

#   def mark_as_failed!(error)
#     update!(
#       status: 'failed',
#       error_message: error
#     )
#   end
end
