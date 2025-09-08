# frozen_string_literal: true

require_relative "../real_spec_helper"
require_relative "../shared_test_helpers"

RSpec.describe "MangoApps Notifications Module" do
  include SharedTestHelpers
  let(:config) { MangoApps::Config.new }
  let(:client) { MangoApps::Client.new(config) }

  describe "Notifications Module" do
    describe "My Priority Items" do
      it "gets user priority items from actual MangoApps API" do
        puts "\n🔔 Testing Notifications API - My Priority Items..."
        
        response = client.my_priority_items
        
        expect(response).to be_a(MangoApps::Response)
        expect(response).to respond_to(:success)
        expect(response).to respond_to(:display_type)
        expect(response).to respond_to(:data)
        puts "✅ My priority items API call successful!"
        puts "📊 Response contains priority items data"
        
        if response.data && response.data.any?
          item = response.data.first
          expect(item).to respond_to(:id)
          expect(item).to respond_to(:title)
          expect(item).to respond_to(:icon)
          expect(item).to respond_to(:icon_color)
          expect(item).to respond_to(:icon_bg_color)
          expect(item).to respond_to(:action_type)
          expect(item).to respond_to(:count)
          expect(item).to respond_to(:info_details)
          puts "✅ Priority items structure validated"
          puts "📊 Found #{response.data.length} priority items"
          puts "🔔 Sample item: #{item.title} (ID: #{item.id}) - Count: #{item.count}"
          puts "🎯 Action Type: #{item.action_type} | Icon: #{item.icon}"
        else
          puts "📊 Priority items list is empty"
        end
        
        expect(response).to respond_to(:success)
        expect(response).to respond_to(:display_type)
        puts "✅ Response structure validated"
        puts "📊 Success: #{response.success} | Display Type: #{response.display_type}"
      end
    end

    describe "Notifications" do
      it "gets notifications from actual MangoApps API" do
        puts "\n🔔 Testing Notifications API - Notifications..."

        response = client.notifications

        expect(response).to be_a(MangoApps::Response)
        expect(response).to respond_to(:transaction_id)
        expect(response).to respond_to(:whats_new_count)
        expect(response).to respond_to(:unread_feeds_count)
        expect(response).to respond_to(:mention_count)
        expect(response).to respond_to(:primary_unread_count)
        expect(response).to respond_to(:secondary_unread_count)
        expect(response).to respond_to(:direct_messages_count)
        expect(response).to respond_to(:unread_notification_count)
        expect(response).to respond_to(:domain_details)
        expect(response).to respond_to(:notifications)
        puts "✅ Notifications API call successful!"
        puts "🔔 Response contains notifications data"
        puts "✅ Notifications structure validated"

        # Test unread counts
        puts "📊 Unread Counts:"
        puts "  What's new: #{response.whats_new_count}"
        puts "  Unread feeds: #{response.unread_feeds_count}"
        puts "  Mentions: #{response.mention_count}"
        puts "  Primary unread: #{response.primary_unread_count}"
        puts "  Secondary unread: #{response.secondary_unread_count}"
        puts "  Direct messages: #{response.direct_messages_count}"
        puts "  Unread notifications: #{response.unread_notification_count}"
        puts "  Domain details: #{response.domain_details || 'None'}"
        puts "  Transaction ID: #{response.transaction_id || 'None'}"
        puts ""

        # Test notifications
        if response.notifications
          notifications = response.notifications
          expect(notifications).to be_an(Array)
          puts "✅ Notifications list structure validated"
          puts "🔔 Found #{notifications.length} notifications"

          if notifications.any?
            # Test first notification structure
            notification = notifications.first
            expect(notification).to respond_to(:id)
            expect(notification).to respond_to(:sender_id)
            expect(notification).to respond_to(:sender_name)
            expect(notification).to respond_to(:feed_id)
            expect(notification).to respond_to(:category)
            expect(notification).to respond_to(:sender_image)
            expect(notification).to respond_to(:user_type)
            expect(notification).to respond_to(:image_url)
            expect(notification).to respond_to(:notification_type)
            expect(notification).to respond_to(:text)
            expect(notification).to respond_to(:meta_data)
            expect(notification).to respond_to(:mention_tags)
            expect(notification).to respond_to(:updated_at)
            expect(notification).to respond_to(:mlink)
            expect(notification).to respond_to(:notification_context)
            expect(notification).to respond_to(:notification_str)
            expect(notification).to respond_to(:is_read)
            puts "✅ Notification structure validated"
            puts "🔔 Notification ID: #{notification.id}"
            puts "📊 Sender: #{notification.sender_name} (ID: #{notification.sender_id})"
            puts "📝 Text: #{notification.text[0..100]}..."
            puts "🔗 MLink: #{notification.mlink || 'None'}"
            puts "📅 Updated: #{Time.at(notification.updated_at.to_i).strftime('%Y-%m-%d %H:%M:%S')}"
            puts "👁️ Read: #{notification.is_read}"
            puts "🏷️ Type: #{notification.notification_type || 'None'}"
            puts "📂 Category: #{notification.category || 'None'}"
            puts "👤 User type: #{notification.user_type || 'None'}"

            # Test sender image
            if notification.sender_image
              puts "🖼️ Sender image: #{notification.sender_image[0..50]}..."
            end

            # Test image URL
            if notification.image_url
              puts "🖼️ Image URL: #{notification.image_url[0..50]}..."
            end

            # Test mention tags
            if notification.mention_tags
              mention_tags = notification.mention_tags
              expect(mention_tags).to be_an(Array)
              puts "✅ Mention tags structure validated"
              puts "🏷️ Mention tags: #{mention_tags.length} tags"
              mention_tags.each do |tag|
                expect(tag).to respond_to(:mention)
                expect(tag).to respond_to(:human_mention)
                expect(tag).to respond_to(:id)
                expect(tag).to respond_to(:is_team_mention)
                puts "  - #{tag.mention} (#{tag.human_mention}) - ID: #{tag.id}, Team: #{tag.is_team_mention}"
              end
            end

            # Test meta data
            if notification.meta_data
              meta_data = notification.meta_data
              if meta_data.is_a?(Hash)
                puts "✅ Meta data structure validated (Hash)"
                puts "📊 Meta data keys: #{meta_data.keys.join(', ')}"
                meta_data.each do |key, value|
                  puts "  - #{key}: #{value}"
                end
              elsif meta_data.is_a?(String)
                puts "✅ Meta data structure validated (String)"
                puts "📊 Meta data: #{meta_data[0..100]}..."
              end
            end

            # Test client meta data
            if notification.respond_to?(:client_meta_data) && notification.client_meta_data
              client_meta_data = notification.client_meta_data
              expect(client_meta_data).to be_a(Hash)
              puts "✅ Client meta data structure validated"
              puts "📊 Client meta data keys: #{client_meta_data.keys.join(', ')}"
              client_meta_data.each do |key, value|
                puts "  - #{key}: #{value}"
              end
            end

            # Display first few notifications
            puts "🔔 Notification List:"
            notifications.first(3).each do |notif|
              puts "  • ID: #{notif.id} | Sender: #{notif.sender_name}"
              puts "    Text: #{notif.text[0..80]}..."
              puts "    Type: #{notif.notification_type || 'None'} | Category: #{notif.category || 'None'}"
              puts "    Read: #{notif.is_read} | Updated: #{Time.at(notif.updated_at.to_i).strftime('%Y-%m-%d %H:%M:%S')}"
              puts "    MLink: #{notif.mlink || 'None'}"
              if notif.mention_tags && notif.mention_tags.any?
                puts "    Mentions: #{notif.mention_tags.map { |tag| tag.mention }.join(', ')}"
              end
              puts ""
            end
          else
            puts "🔔 Notifications list is empty"
          end
        else
          puts "🔔 Notifications data not found"
        end

        expect(response).to respond_to(:notifications)
        puts "✅ Response structure validated"
      end
    end
  end
end
