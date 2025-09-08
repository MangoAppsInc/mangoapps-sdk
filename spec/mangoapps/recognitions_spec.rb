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

    describe "Get Award Feeds" do
      it "gets award feeds from actual MangoApps API" do
        puts "\n🏆 Testing Recognitions API - Get Award Feeds..."

        response = client.get_award_feeds

        expect(response).to be_a(MangoApps::Response)
        expect(response).to respond_to(:transaction_id)
        expect(response).to respond_to(:limit)
        expect(response).to respond_to(:current_priority)
        expect(response).to respond_to(:enable_mobile_pin)
        expect(response).to respond_to(:mangoapps_version)
        expect(response).to respond_to(:comments_order)
        expect(response).to respond_to(:private_message_reply_order)
        expect(response).to respond_to(:photo_shape)
        expect(response).to respond_to(:moderation_feed_ids)
        expect(response).to respond_to(:moderation_html)
        expect(response).to respond_to(:unread_counts)
        expect(response).to respond_to(:feeds)
        puts "✅ Get award feeds API call successful!"
        puts "🏆 Response contains award feeds data"
        puts "✅ Award feeds structure validated"

        # Test unread counts
        if response.unread_counts
          unread_counts = response.unread_counts
            expect(unread_counts).to respond_to(:direct_messages_count)
            expect(unread_counts).to respond_to(:whats_new_count)
            expect(unread_counts).to respond_to(:unread_feeds_count)
            expect(unread_counts).to respond_to(:mention_count)
            expect(unread_counts).to respond_to(:primary_unread_count)
            expect(unread_counts).to respond_to(:secondary_unread_count)
            expect(unread_counts).to respond_to(:unread_notification_count)
            puts "✅ Unread counts structure validated"
            puts "📊 Direct messages: #{unread_counts.direct_messages_count}"
            puts "📊 What's new: #{unread_counts.whats_new_count}"
            puts "📊 Unread feeds: #{unread_counts.unread_feeds_count}"
            puts "📊 Mentions: #{unread_counts.mention_count}"
            puts "📊 Primary unread: #{unread_counts.primary_unread_count}"
            puts "📊 Secondary unread: #{unread_counts.secondary_unread_count}"
            puts "📊 Unread notifications: #{unread_counts.unread_notification_count}"
          end

        # Test feeds
        if response.feeds
          feeds = response.feeds
            expect(feeds).to be_an(Array)
            puts "✅ Feeds structure validated"
            puts "🏆 Found #{feeds.length} award feeds"

            if feeds.any?
              # Test first feed structure
              feed = feeds.first
              expect(feed).to respond_to(:id)
              expect(feed).to respond_to(:feed_type)
              expect(feed).to respond_to(:body)
              expect(feed).to respond_to(:shared_in_conversations)
              expect(feed).to respond_to(:shared_with_multiple_user)
              expect(feed).to respond_to(:feed_subject)
              expect(feed).to respond_to(:email_extra_info)
              expect(feed).to respond_to(:mention_tags)
              expect(feed).to respond_to(:hash_tags)
              expect(feed).to respond_to(:mlink)
              expect(feed).to respond_to(:category)
              expect(feed).to respond_to(:is_system)
              expect(feed).to respond_to(:is_link)
              expect(feed).to respond_to(:shareable)
              expect(feed).to respond_to(:sub_category)
              expect(feed).to respond_to(:session_id)
              expect(feed).to respond_to(:visibility)
              expect(feed).to respond_to(:is_highlighted)
              expect(feed).to respond_to(:is_edited)
              expect(feed).to respond_to(:is_ack)
              expect(feed).to respond_to(:is_boost_post_dm)
              expect(feed).to respond_to(:msg_content_type)
              expect(feed).to respond_to(:message_content_url)
              expect(feed).to respond_to(:can_flag)
              expect(feed).to respond_to(:feed_status_type)
              expect(feed).to respond_to(:from_user)
              expect(feed).to respond_to(:is_automation_feed)
              expect(feed).to respond_to(:has_stories)
              expect(feed).to respond_to(:feed_story_users)
              expect(feed).to respond_to(:remaining_user_count)
              expect(feed).to respond_to(:to_users)
              expect(feed).to respond_to(:recognition_points)
              expect(feed).to respond_to(:reward_points)
              expect(feed).to respond_to(:core_value_tags)
              expect(feed).to respond_to(:feed_property)
              expect(feed).to respond_to(:group_id)
              expect(feed).to respond_to(:platform)
              expect(feed).to respond_to(:liked)
              expect(feed).to respond_to(:superliked)
              expect(feed).to respond_to(:haha)
              expect(feed).to respond_to(:yay)
              expect(feed).to respond_to(:wow)
              expect(feed).to respond_to(:sad)
              expect(feed).to respond_to(:like_count)
              expect(feed).to respond_to(:superlike_count)
              expect(feed).to respond_to(:haha_count)
              expect(feed).to respond_to(:yay_count)
              expect(feed).to respond_to(:wow_count)
              expect(feed).to respond_to(:sad_count)
              expect(feed).to respond_to(:reaction_data)
              expect(feed).to respond_to(:comment_count)
              expect(feed).to respond_to(:attachment_count)
              expect(feed).to respond_to(:liked_list)
              expect(feed).to respond_to(:watched)
              expect(feed).to respond_to(:unread)
              expect(feed).to respond_to(:comments)
              expect(feed).to respond_to(:created_at)
              expect(feed).to respond_to(:updated_at)
              puts "✅ Feed structure validated"
              puts "🏆 Feed ID: #{feed.id} | Type: #{feed.feed_type}"
              puts "📊 Category: #{feed.category} | Sub-category: #{feed.sub_category}"
              puts "🔗 MLink: #{feed.mlink}"
              puts "👤 From user: #{feed.from_user.name if feed.from_user}"
              puts "🎯 Recognition points: #{feed.recognition_points}"
              puts "🏷️ Core value tags: #{feed.core_value_tags.length if feed.core_value_tags}"
              puts "👍 Reactions: Like: #{feed.like_count}, Superlike: #{feed.superlike_count}"
              puts "😄 Reactions: Haha: #{feed.haha_count}, Yay: #{feed.yay_count}, Wow: #{feed.wow_count}, Sad: #{feed.sad_count}"
              puts "💬 Comments: #{feed.comment_count} | Attachments: #{feed.attachment_count}"
              puts "📅 Created: #{Time.at(feed.created_at.to_i).strftime('%Y-%m-%d %H:%M:%S')}"
              puts "📅 Updated: #{Time.at(feed.updated_at.to_i).strftime('%Y-%m-%d %H:%M:%S')}"

              # Test feed property
              if feed.feed_property
                feed_property = feed.feed_property
                expect(feed_property).to respond_to(:stripped_description)
                expect(feed_property).to respond_to(:status)
                expect(feed_property).to respond_to(:title)
                expect(feed_property).to respond_to(:image_url)
                expect(feed_property).to respond_to(:icon_properties)
                expect(feed_property).to respond_to(:additional_info_url)
                expect(feed_property).to respond_to(:label_1)
                expect(feed_property).to respond_to(:label_2)
                expect(feed_property).to respond_to(:label_3)
                expect(feed_property).to respond_to(:result_format)
                expect(feed_property).to respond_to(:custom_poll_choices)
                expect(feed_property).to respond_to(:feed_poll_notify)
                expect(feed_property).to respond_to(:poll_multiple_vote_allowed)
                expect(feed_property).to respond_to(:poll_close_time)
                expect(feed_property).to respond_to(:allow_poll_comment)
                expect(feed_property).to respond_to(:custom_labels)
                expect(feed_property).to respond_to(:status_updated_by)
                expect(feed_property).to respond_to(:priority)
                expect(feed_property).to respond_to(:priority_date)
                expect(feed_property).to respond_to(:label_4)
                puts "✅ Feed property structure validated"
                puts "🏆 Award title: #{feed_property.title}"
                puts "🏷️ Labels: #{feed_property.label_1} | #{feed_property.label_2}"
                puts "🖼️ Image URL: #{feed_property.image_url[0..50]}..." if feed_property.image_url
                puts "📊 Status: #{feed_property.status} | Result format: #{feed_property.result_format}"
              end

              # Test from user
              if feed.from_user
                from_user = feed.from_user
                expect(from_user).to respond_to(:id)
                expect(from_user).to respond_to(:name)
                expect(from_user).to respond_to(:email)
                expect(from_user).to respond_to(:photo)
                expect(from_user).to respond_to(:presence_option_id)
                puts "✅ From user structure validated"
                puts "👤 User: #{from_user.name} (ID: #{from_user.id})"
                puts "📧 Email: #{from_user.email}"
                puts "🖼️ Photo: #{from_user.photo[0..50]}..." if from_user.photo
              end

              # Test to users
              if feed.to_users
                to_users = feed.to_users
                expect(to_users).to be_an(Array)
                puts "✅ To users structure validated"
                puts "👥 To users: #{to_users.length} users"
                to_users.each do |user|
                  expect(user).to respond_to(:id)
                  expect(user).to respond_to(:name)
                  expect(user).to respond_to(:email)
                  expect(user).to respond_to(:photo)
                  expect(user).to respond_to(:presence_option_id)
                  puts "  - #{user.name} (ID: #{user.id})"
                end
              end

              # Test feed story users
              if feed.feed_story_users
                feed_story_users = feed.feed_story_users
                expect(feed_story_users).to be_an(Array)
                puts "✅ Feed story users structure validated"
                puts "📖 Story users: #{feed_story_users.length} users"
                feed_story_users.each do |user|
                  expect(user).to respond_to(:id)
                  expect(user).to respond_to(:name)
                  expect(user).to respond_to(:email)
                  expect(user).to respond_to(:photo)
                  expect(user).to respond_to(:presence_option_id)
                  puts "  - #{user.name} (ID: #{user.id})"
                end
              end

              # Test core value tags
              if feed.core_value_tags
                core_value_tags = feed.core_value_tags
                expect(core_value_tags).to be_an(Array)
                puts "✅ Core value tags structure validated"
                puts "🏷️ Core value tags: #{core_value_tags.length} tags"
                core_value_tags.each do |tag|
                  expect(tag).to respond_to(:id)
                  expect(tag).to respond_to(:name)
                  expect(tag).to respond_to(:color)
                  puts "  - #{tag.name} (ID: #{tag.id}, Color: #{tag.color})"
                end
              end

              # Test reaction data
              if feed.reaction_data
                reaction_data = feed.reaction_data
                expect(reaction_data).to be_an(Array)
                puts "✅ Reaction data structure validated"
                puts "📊 Reaction data: #{reaction_data.length} reaction types"
                reaction_data.each do |reaction|
                  expect(reaction).to respond_to(:key)
                  expect(reaction).to respond_to(:count)
                  expect(reaction).to respond_to(:reacted)
                  expect(reaction).to respond_to(:label)
                  puts "  - #{reaction.label}: #{reaction.count} (Reacted: #{reaction.reacted})"
                end
              end

              # Test comments
              if feed.comments
                comments = feed.comments
                expect(comments).to be_an(Array)
                puts "✅ Comments structure validated"
                puts "💬 Comments: #{comments.length} comments"
                comments.first(3).each do |comment|
                  expect(comment).to respond_to(:id)
                  expect(comment).to respond_to(:feed_id)
                  expect(comment).to respond_to(:body)
                  expect(comment).to respond_to(:created_at)
                  expect(comment).to respond_to(:updated_at)
                  expect(comment).to respond_to(:user)
                  puts "  - #{comment.body[0..50]}... by #{comment.user.name if comment.user}"
                end
              end

              # Display first few feeds
              puts "🏆 Award Feed List:"
              feeds.first(3).each do |f|
                puts "  • Feed ID: #{f.id} | Type: #{f.feed_type}"
                puts "    Category: #{f.category} | Recognition points: #{f.recognition_points}"
                puts "    From: #{f.from_user.name if f.from_user} | To: #{f.to_users.length if f.to_users} users"
                puts "    Reactions: Like: #{f.like_count}, Superlike: #{f.superlike_count}"
                puts "    Comments: #{f.comment_count} | Created: #{Time.at(f.created_at.to_i).strftime('%Y-%m-%d')}"
                if f.feed_property
                  puts "    Award: #{f.feed_property.title} | Labels: #{f.feed_property.label_1}, #{f.feed_property.label_2}"
                end
                puts ""
              end
            else
              puts "🏆 Award feeds list is empty"
            end
          else
            puts "🏆 Feeds data not found"
          end

        # Test other response properties
        puts "📊 Transaction ID: #{response.transaction_id || 'None'}"
        puts "📊 Limit: #{response.limit || 'None'}"
        puts "📊 Current priority: #{response.current_priority || 'None'}"
        puts "📊 Enable mobile pin: #{response.enable_mobile_pin}"
        puts "📊 MangoApps version: #{response.mangoapps_version}"
        puts "📊 Comments order: #{response.comments_order}"
        puts "📊 Private message reply order: #{response.private_message_reply_order || 'None'}"
        puts "📊 Photo shape: #{response.photo_shape || 'None'}"
        puts "📊 Moderation feed IDs: #{response.moderation_feed_ids || 'None'}"
        puts "📊 Moderation HTML: #{response.moderation_html || 'None'}"

        expect(response).to respond_to(:feeds)
        puts "✅ Response structure validated"
      end
    end
  end
end
