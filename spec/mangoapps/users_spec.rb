# frozen_string_literal: true

require_relative "../real_spec_helper"
require_relative "../shared_test_helpers"

RSpec.describe "MangoApps Users Module" do
  include SharedTestHelpers
  let(:config) { MangoApps::Config.new }
  let(:client) { MangoApps::Client.new(config) }

  before do
    # Ensure we have a valid token
    unless config.has_valid_token?
      skip "No valid access token found. Run OAuth tests first."
    end
  end


  describe "User Profile" do
    it "gets current user info" do
      puts "\n👤 Testing Users API - Current User Profile..."
      
      response = client.me
      
      expect(response).to be_a(Hash) # Users API returns parsed JSON
      expect(response).to have_key("ms_response")
      expect(response["ms_response"]).to have_key("user_profile")
      puts "✅ User profile API call successful!"
      puts "📊 Response contains user profile data"
      
      # Validate the user profile structure
      user_profile = response["ms_response"]["user_profile"]
      
      # Validate minimal_profile structure
      expect(user_profile).to have_key("minimal_profile")
      minimal_profile = user_profile["minimal_profile"]
      
      expect(minimal_profile).to have_key("id")
      expect(minimal_profile).to have_key("name")
      expect(minimal_profile).to have_key("user_type")
      expect(minimal_profile).to have_key("user_first_name")
      expect(minimal_profile).to have_key("user_last_name")
      expect(minimal_profile).to have_key("email")
      expect(minimal_profile).to have_key("user_mention")
      expect(minimal_profile).to have_key("photo")
      expect(minimal_profile).to have_key("image_url")
      
      # Validate user_data structure
      expect(user_profile).to have_key("user_data")
      user_data = user_profile["user_data"]
      
      expect(user_data).to have_key("state")
      expect(user_data).to have_key("followers")
      expect(user_data).to have_key("following")
      expect(user_data).to have_key("created_at")
      expect(user_data).to have_key("time_zone")
      
      # Validate gamification structure
      expect(user_profile).to have_key("gamification")
      gamification = user_profile["gamification"]
      
      expect(gamification).to have_key("current_level")
      expect(gamification).to have_key("current_points")
      expect(gamification).to have_key("total_points")
      expect(gamification).to have_key("badges")
      expect(gamification["badges"]).to be_a(Array)
      
      # Validate recognition structure
      expect(user_profile).to have_key("recognition")
      recognition = user_profile["recognition"]
      
      expect(recognition).to have_key("total_reward_points_received")
      expect(recognition).to have_key("total_reward_points_allocated")
      
      puts "✅ User profile structure validated"
      puts "📊 User ID: #{minimal_profile['id']}"
      puts "📊 User Name: #{minimal_profile['name']}"
      puts "📊 User Email: #{minimal_profile['email']}"
      puts "📊 User Type: #{minimal_profile['user_type']}"
      puts "📊 Followers: #{user_data['followers']}"
      puts "📊 Following: #{user_data['following']}"
      puts "📊 Current Level: #{gamification['current_level']}"
      puts "📊 Total Points: #{gamification['total_points']}"
      puts "📊 Badges Count: #{gamification['badges'].length}"
    end
  end

end
