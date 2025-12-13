class CreateVoiceGenerations < ActiveRecord::Migration[8.1]
  def change
    create_table :voice_generations do |t|
      t.text :text, null: false
      t.string :status, null: false, default: 'pending'
      t.string :audio_url
      t.text :error_message
      t.jsonb :metadata, default: {}

      t.timestamps
    end
  end
end