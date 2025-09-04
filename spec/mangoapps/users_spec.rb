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
      
      expect(response).to be_a(MangoApps::Response) # Users API returns wrapped response
      expect(response).to respond_to(:user_profile)
      puts "✅ User profile API call successful!"
      puts "📊 Response contains user profile data"
      
      # Validate the user profile structure
      user_profile = response.user_profile
      
      # Validate minimal_profile structure using dot notation
      expect(user_profile).to respond_to(:minimal_profile)
      minimal_profile = user_profile.minimal_profile
      
      expect(minimal_profile).to respond_to(:id)
      expect(minimal_profile).to respond_to(:name)
      expect(minimal_profile).to respond_to(:user_type)
      expect(minimal_profile).to respond_to(:user_first_name)
      expect(minimal_profile).to respond_to(:user_last_name)
      expect(minimal_profile).to respond_to(:email)
      expect(minimal_profile).to respond_to(:user_mention)
      expect(minimal_profile).to respond_to(:photo)
      expect(minimal_profile).to respond_to(:image_url)
      
      # Validate user_data structure using dot notation
      expect(user_profile).to respond_to(:user_data)
      user_data = user_profile.user_data
      
      expect(user_data).to respond_to(:state)
      expect(user_data).to respond_to(:followers)
      expect(user_data).to respond_to(:following)
      expect(user_data).to respond_to(:created_at)
      expect(user_data).to respond_to(:time_zone)
      
      # Validate gamification structure using dot notation
      expect(user_profile).to respond_to(:gamification)
      gamification = user_profile.gamification
      
      expect(gamification).to respond_to(:current_level)
      expect(gamification).to respond_to(:current_points)
      expect(gamification).to respond_to(:total_points)
      expect(gamification).to respond_to(:badges)
      expect(gamification.badges).to be_a(Array)
      
      # Validate recognition structure using dot notation
      expect(user_profile).to respond_to(:recognition)
      recognition = user_profile.recognition
      
      expect(recognition).to respond_to(:total_reward_points_received)
      expect(recognition).to respond_to(:total_reward_points_allocated)
      
      puts "✅ User profile structure validated"
      puts "📊 User ID: #{minimal_profile.id}"
      puts "📊 User Name: #{minimal_profile.name}"
      puts "📊 User Email: #{minimal_profile.email}"
      puts "📊 User Type: #{minimal_profile.user_type}"
      puts "📊 Followers: #{user_data.followers}"
      puts "📊 Following: #{user_data.following}"
      puts "📊 Current Level: #{gamification.current_level}"
      puts "📊 Total Points: #{gamification.total_points}"
      puts "📊 Badges Count: #{gamification.badges.length}"
    end
  end

end
