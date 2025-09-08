# frozen_string_literal: true

require_relative "../real_spec_helper"
require_relative "../shared_test_helpers"

RSpec.describe "MangoApps Feeds Module" do
  include SharedTestHelpers
  let(:config) { MangoApps::Config.new }
  let(:client) { MangoApps::Client.new(config) }

  describe "Feeds Module" do
    describe "Feeds" do
      it "gets feeds from actual MangoApps API" do
        puts "\n📰 Testing Feeds API - Get Feeds..."
        
        response = client.feeds
        
        expect(response).to be_a(MangoApps::Response)
        expect(response).to respond_to(:feeds)
        expect(response).to respond_to(:unread_counts)
        expect(response).to respond_to(:limit)
        expect(response).to respond_to(:mangoapps_version)
        puts "✅ Feeds API call successful!"
        puts "📊 Response contains feeds data"
        
        if response.feeds && response.feeds.any?
          feed = response.feeds.first
          expect(feed).to respond_to(:id)
          expect(feed).to respond_to(:feed_type)
          expect(feed).to respond_to(:body)
          expect(feed).to respond_to(:from_user)
          expect(feed).to respond_to(:group_id)
          expect(feed).to respond_to(:group_name)
          expect(feed).to respond_to(:created_at)
          expect(feed).to respond_to(:updated_at)
          puts "✅ Feeds structure validated"
          puts "📊 Found #{response.feeds.length} feeds"
          puts "📰 Sample feed: #{feed.feed_property.title} (ID: #{feed.id})"
          puts "👤 From: #{feed.from_user.name} | Group: #{feed.group_name}"
          puts "📅 Created: #{Time.at(feed.created_at.to_i).strftime('%Y-%m-%d %H:%M:%S')}"
        else
          puts "📊 Feeds list is empty"
        end
        
        expect(response).to respond_to(:unread_counts)
        expect(response).to respond_to(:limit)
        expect(response).to respond_to(:mangoapps_version)
        puts "✅ Response structure validated"
        puts "📊 Limit: #{response.limit} | Version: #{response.mangoapps_version}"
        
        if response.unread_counts
          expect(response.unread_counts).to respond_to(:unread_feeds_count)
          expect(response.unread_counts).to respond_to(:direct_messages_count)
          expect(response.unread_counts).to respond_to(:whats_new_count)
          puts "✅ Unread counts structure validated"
          puts "📊 Unread feeds: #{response.unread_counts.unread_feeds_count}"
          puts "📊 Direct messages: #{response.unread_counts.direct_messages_count}"
          puts "📊 What's new: #{response.unread_counts.whats_new_count}"
        end
      end
    end
  end
end
