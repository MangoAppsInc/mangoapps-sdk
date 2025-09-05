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

  describe "Tango Gift Cards" do
    it "gets tango gift cards from actual MangoApps API" do
      puts "\n🎁 Testing Recognitions API - Tango Gift Cards..."
      
      response = client.tango_gift_cards
      
      expect(response).to be_a(MangoApps::Response) # Recognitions API returns wrapped response
      expect(response).to respond_to(:tango_cards)
      puts "✅ Tango gift cards API call successful!"
      puts "📊 Response contains tango gift cards data"
      
      # Validate the tango gift card structure using dot notation
      if response.tango_cards
        expect(response.tango_cards).to respond_to(:available_points)
        expect(response.tango_cards).to respond_to(:terms)
        puts "✅ Tango gift cards structure validated"
        puts "📊 Available points: #{response.tango_cards.available_points}"
        puts "🎁 Terms: #{response.tango_cards.terms[0..100]}..." if response.tango_cards.terms
      else
        puts "📊 Tango gift cards data is nil"
      end
    end
  end

  describe "Gift Cards" do
    it "gets gift cards from actual MangoApps API" do
      puts "\n🎁 Testing Recognitions API - Gift Cards..."
      
      response = client.gift_cards
      
      expect(response).to be_a(MangoApps::Response) # Recognitions API returns wrapped response
      expect(response).to respond_to(:cards)
      expect(response.cards).to be_an(Array)
      puts "✅ Gift cards API call successful!"
      puts "📊 Response contains gift cards data"
      
      # Validate the gift card structure using dot notation
      if response.cards.any?
        gift_card = response.cards.first
        expect(gift_card).to respond_to(:brand_key)
        expect(gift_card).to respond_to(:brand_name)
        expect(gift_card).to respond_to(:description)
        expect(gift_card).to respond_to(:enabled)
        puts "✅ Gift cards structure validated"
        puts "📊 Found #{response.cards.length} gift cards"
        puts "🎁 Sample gift card: #{gift_card.brand_name} (Key: #{gift_card.brand_key}) - Enabled: #{gift_card.enabled}"
      else
        puts "📊 Gift cards list is empty"
      end
    end
  end

  describe "Get Awards List" do
    it "gets awards list for specific category from actual MangoApps API" do
      puts "\n🏆 Testing Recognitions API - Get Awards List..."
      
      # Use a known category ID from the award categories test
      category_id = 4303  # Safety & Quality category
      response = client.get_awards_list(category_id: category_id)
      
      expect(response).to be_a(MangoApps::Response) # Recognitions API returns wrapped response
      expect(response).to respond_to(:get_awards_list)
      expect(response.get_awards_list).to be_an(Array)
      puts "✅ Get awards list API call successful!"
      puts "📊 Response contains awards list data for category #{category_id}"
      
      # Validate the award structure using dot notation
      if response.get_awards_list.any?
        award = response.get_awards_list.first
        expect(award).to respond_to(:id)
        expect(award).to respond_to(:name)
        expect(award).to respond_to(:description)
        expect(award).to respond_to(:points)
        expect(award).to respond_to(:attachment_url)
        expect(award).to respond_to(:reward_points)
        puts "✅ Awards list structure validated"
        puts "📊 Found #{response.get_awards_list.length} awards in category"
        puts "🏆 Sample award: #{award.name} (ID: #{award.id}) - Points: #{award.points} - Reward Points: #{award.reward_points}"
      else
        puts "📊 Awards list is empty for category #{category_id}"
      end
    end
  end

  describe "Get Profile Awards" do
    it "gets user profile awards from actual MangoApps API" do
      puts "\n🏆 Testing Recognitions API - Get Profile Awards..."
      
      response = client.get_profile_awards
      
      expect(response).to be_a(MangoApps::Response) # Recognitions API returns wrapped response
      expect(response).to respond_to(:core_value_tags)
      expect(response).to respond_to(:feeds)
      expect(response).to respond_to(:unread_counts)
      puts "✅ Get profile awards API call successful!"
      puts "📊 Response contains profile awards data"
      
      # Validate core value tags structure
      if response.core_value_tags.any?
        tag = response.core_value_tags.first
        expect(tag).to respond_to(:id)
        expect(tag).to respond_to(:name)
        expect(tag).to respond_to(:color)
        expect(tag).to respond_to(:count)
        puts "✅ Core value tags structure validated"
        puts "📊 Found #{response.core_value_tags.length} core value tags"
        puts "🎯 Sample tag: #{tag.name} (ID: #{tag.id}) - Count: #{tag.count}"
      else
        puts "📊 Core value tags list is empty"
      end
      
      # Validate feeds structure
      if response.feeds.any?
        feed = response.feeds.first
        expect(feed).to respond_to(:id)
        expect(feed).to respond_to(:body)
        expect(feed).to respond_to(:recognition_points)
        expect(feed).to respond_to(:from_user)
        expect(feed).to respond_to(:feed_property)
        puts "✅ Feeds structure validated"
        puts "📊 Found #{response.feeds.length} award feeds"
        puts "🏆 Sample feed: #{feed.feed_property.title} - Points: #{feed.recognition_points}"
      else
        puts "📊 Feeds list is empty"
      end
      
      # Validate unread counts structure
      if response.unread_counts
        expect(response.unread_counts).to respond_to(:unread_notification_count)
        puts "✅ Unread counts structure validated"
        puts "📊 Unread notifications: #{response.unread_counts.unread_notification_count}"
      end
    end
  end

  describe "Get Team Awards" do
    it "gets team awards for specific project from actual MangoApps API" do
      puts "\n🏆 Testing Recognitions API - Get Team Awards..."
      
      # Use a known project ID from the example
      project_id = 117747  # All Users team
      response = client.get_team_awards(project_id: project_id)
      
      expect(response).to be_a(MangoApps::Response) # Recognitions API returns wrapped response
      expect(response).to respond_to(:core_value_tags)
      expect(response).to respond_to(:feeds)
      expect(response).to respond_to(:unread_counts)
      puts "✅ Get team awards API call successful!"
      puts "📊 Response contains team awards data for project #{project_id}"
      
      # Validate core value tags structure
      if response.core_value_tags.any?
        tag = response.core_value_tags.first
        expect(tag).to respond_to(:id)
        expect(tag).to respond_to(:name)
        expect(tag).to respond_to(:color)
        expect(tag).to respond_to(:count)
        puts "✅ Core value tags structure validated"
        puts "📊 Found #{response.core_value_tags.length} core value tags"
        puts "🎯 Sample tag: #{tag.name} (ID: #{tag.id}) - Count: #{tag.count}"
      else
        puts "📊 Core value tags list is empty"
      end
      
      # Validate feeds structure
      if response.feeds.any?
        feed = response.feeds.first
        expect(feed).to respond_to(:id)
        expect(feed).to respond_to(:body)
        expect(feed).to respond_to(:recognition_points)
        expect(feed).to respond_to(:from_user)
        expect(feed).to respond_to(:feed_property)
        expect(feed).to respond_to(:group_id)
        expect(feed).to respond_to(:group_name)
        puts "✅ Feeds structure validated"
        puts "📊 Found #{response.feeds.length} team award feeds"
        puts "🏆 Sample feed: #{feed.feed_property.title} - Points: #{feed.recognition_points}"
        puts "👥 Team: #{feed.group_name} (ID: #{feed.group_id})"
      else
        puts "📊 Feeds list is empty"
      end
      
      # Validate unread counts structure
      if response.unread_counts
        expect(response.unread_counts).to respond_to(:unread_notification_count)
        puts "✅ Unread counts structure validated"
        puts "📊 Unread notifications: #{response.unread_counts.unread_notification_count}"
      end
    end
  end
end
