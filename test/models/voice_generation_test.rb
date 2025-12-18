require "test_helper"

class VoiceGenerationTest < ActiveSupport::TestCase
  test "should not save without text" do
    voice_generation = VoiceGeneration.new
    assert_not voice_generation.save
  end

  test "should have pending status by default" do
    voice_generation = VoiceGeneration.create!(text: "Test")
    assert_equal "pending", voice_generation.status
  end
end
