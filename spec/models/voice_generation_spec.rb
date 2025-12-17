require 'rails_helper'

RSpec.describe VoiceGeneration, type: :model do
    describe 'validations' do
        it 'is valid with text and status' do
            vg = VoiceGeneration.new(text: "Hello World", status: 'pending')
            expect(vg.valid?).to be true
        end

        it 'is invalid without text' do
            vg = VoiceGeneration.new(status: 'pending')
            expect(vg.valid?).to be false
        end

        it 'is invalid with empty text' do
            vg = VoiceGeneration.new(text: '', status: 'pending')
            expect(vg.valid?).to be false
        end

        it 'is invalid with text too long' do
            vg = VoiceGeneration.new(text: 'a' * 6000, status: 'pending')
            expect(vg.valid?).to be false
        end

        it 'is invalid without status' do
            vg = VoiceGeneration.new(text: 'Hello', status: '')
            expect(vg.valid?).to be false
        end

        it 'only allows valid status values' do
            valid_statuses = %w[pending processing completed failed]
            valid_statuses.each do |status|
                vg = VoiceGeneration.new(text: 'Test', status: status)
                expect(vg.valid?).to be true
            end

            vg = VoiceGeneration.new(text: 'Test', status: 'invalid')
            expect(vg.valid?).to be false
        end
    end
end










        















