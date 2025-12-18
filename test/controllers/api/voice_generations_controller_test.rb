require "test_helper"

class Api::VoiceGenerationsControllerTest < ActionDispatch::IntegrationTest
  test "should create voice generation" do
    assert_difference("VoiceGeneration.count") do
      post api_voice_generations_url,
        params: {voice_generation: { text: "Hello world" } }
        as: :json
    end

    assert_response :created
    json = JSON.parse(response.body)
    assert_equal "pending", json["status"]
  end

  test "should not create without text" do
    assert_no_difference("VoiceGeneration.count") do
      post api_voice_generation_url,
        params: {voice_generation: {text: ""}}
        as: :json
    end

    assert_response :unprocessable_entity
  end

  test "should show voice generation" do
    voice_generation = voice_generations(:one)
    get api_voice_generation_url(voice_generation), as: :json

    assert_response :success
    json = JSON.parse(response.body)
    assert_equal voice_generation.id, json["id"]
  end

  test "should list voice generations" do
    get api_voice_generation_url, as: :json

    assert_response :success
    json = JSON.parse(response.body)
    assert json["voice_generations"].is_a?(Array)
  end
end


  
