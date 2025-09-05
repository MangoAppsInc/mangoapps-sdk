# frozen_string_literal: true

require_relative "../real_spec_helper"
require_relative "../shared_test_helpers"

RSpec.describe "MangoApps Recognitions Module" do
  include SharedTestHelpers
  let(:config) { MangoApps::Config.new }
  let(:client) { MangoApps::Client.new(config) }

  before do
    # Ensure we have a valid token
    unless config.has_valid_token?
      skip "No valid access token found. Run OAuth tests first."
    end
  end

  describe "Award Categories" do
    it "gets award categories from actual MangoApps API" do
      puts "\n🏆 Testing Recognitions API - Award Categories..."
      
      response = client.award_categories
      
      expect(response).to be_a(MangoApps::Response) # Recognitions API returns wrapped response
      expect(response).to respond_to(:award_categories)
      expect(response.award_categories).to be_an(Array)
      puts "✅ Award categories API call successful!"
      puts "📊 Response contains award categories data"
      
      # Validate the award category structure using dot notation
      if response.award_categories.any?
        category = response.award_categories.first
        expect(category).to respond_to(:id)
        expect(category).to respond_to(:name)
        expect(category).to respond_to(:recipient_permission)
        puts "✅ Award categories structure validated"
        puts "📊 Found #{response.award_categories.length} award categories"
        puts "🏆 Sample category: #{category.name} (ID: #{category.id}) - Permission: #{category.recipient_permission}"
      else
        puts "📊 Award categories list is empty"
      end
    end
  end

  describe "Core Value Tags" do
    it "gets core value tags from actual MangoApps API" do
      puts "\n🎯 Testing Recognitions API - Core Value Tags..."
      
      response = client.core_value_tags
      
      expect(response).to be_a(MangoApps::Response) # Recognitions API returns wrapped response
      expect(response).to respond_to(:core_value_tags)
      expect(response.core_value_tags).to be_an(Array)
      puts "✅ Core value tags API call successful!"
      puts "📊 Response contains core value tags data"
      
      # Validate the core value tag structure using dot notation
      if response.core_value_tags.any?
        tag = response.core_value_tags.first
        expect(tag).to respond_to(:id)
        expect(tag).to respond_to(:name)
        expect(tag).to respond_to(:color)
        puts "✅ Core value tags structure validated"
        puts "📊 Found #{response.core_value_tags.length} core value tags"
        puts "🎯 Sample tag: #{tag.name} (ID: #{tag.id}) - Color: ##{tag.color}"
      else
        puts "📊 Core value tags list is empty"
      end
    end
  end

  describe "Leaderboard Info" do
    it "gets leaderboard info from actual MangoApps API" do
      puts "\n🏅 Testing Recognitions API - Leaderboard Info..."
      
      response = client.leaderboard_info
      
      expect(response).to be_a(MangoApps::Response) # Recognitions API returns wrapped response
      expect(response).to respond_to(:leaderboard_info)
      puts "✅ Leaderboard info API call successful!"
      puts "📊 Response contains leaderboard data structure"
      
      # Handle case where leaderboard_info might be nil (no data configured)
      if response.leaderboard_info.nil?
        puts "📊 Leaderboard info is nil - no leaderboard data configured"
        puts "✅ API endpoint is accessible and working correctly"
        # Test passes - API is working but no data is configured
      else
        # Validate the leaderboard structure when data is present
        expect(response.leaderboard_info).to respond_to(:user_info)
        expect(response.leaderboard_info).to respond_to(:team_info)
        expect(response.leaderboard_info.user_info).to be_an(Array)
        expect(response.leaderboard_info.team_info).to be_an(Array)
        puts "📊 Response contains leaderboard data"
        
        # Validate the user info structure using dot notation
        if response.leaderboard_info.user_info.any?
          user = response.leaderboard_info.user_info.first
          expect(user).to respond_to(:id)
          expect(user).to respond_to(:name)
          expect(user).to respond_to(:user_image)
          expect(user).to respond_to(:award_count)
          expect(user).to respond_to(:rank)
          puts "✅ User leaderboard structure validated"
          puts "📊 Found #{response.leaderboard_info.user_info.length} users in leaderboard"
          puts "🏅 Top user: #{user.name} (Rank: #{user.rank}) - Awards: #{user.award_count}"
        else
          puts "📊 User leaderboard is empty"
        end
        
        # Validate the team info structure using dot notation
        if response.leaderboard_info.team_info.any?
          team = response.leaderboard_info.team_info.first
          expect(team).to respond_to(:id)
          expect(team).to respond_to(:name)
          expect(team).to respond_to(:conv_image_url)
          expect(team).to respond_to(:award_count)
          expect(team).to respond_to(:rank)
          puts "✅ Team leaderboard structure validated"
          puts "📊 Found #{response.leaderboard_info.team_info.length} teams in leaderboard"
          puts "🏅 Top team: #{team.name} (Rank: #{team.rank}) - Awards: #{team.award_count}"
        else
          puts "📊 Team leaderboard is empty"
        end
      end
    end
  end
end
