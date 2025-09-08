# frozen_string_literal: true

require_relative "../real_spec_helper"
require_relative "../shared_test_helpers"

RSpec.describe "MangoApps Trackers Module" do
  include SharedTestHelpers
  let(:config) { MangoApps::Config.new }
  let(:client) { MangoApps::Client.new(config) }

  describe "Trackers Module" do
    describe "Get Trackers" do
      it "gets user trackers from actual MangoApps API" do
        puts "\n📊 Testing Trackers API - Get Trackers..."

        response = client.get_trackers

        expect(response).to be_a(MangoApps::Response)
        expect(response).to respond_to(:trackers)
        puts "✅ Get trackers API call successful!"
        puts "📊 Response contains trackers data"

        if response.trackers
          trackers = response.trackers
          expect(trackers).to be_an(Array)
          puts "✅ Trackers structure validated"
          puts "📊 Found #{trackers.length} trackers"

          if trackers.any?
            tracker = trackers.first
            expect(tracker).to respond_to(:id)
            expect(tracker).to respond_to(:name)
            expect(tracker).to respond_to(:last_submission_date)
            expect(tracker).to respond_to(:is_pinned)
            expect(tracker).to respond_to(:tracker_icon_info)
            expect(tracker).to respond_to(:mlink)
            expect(tracker).to respond_to(:conversation_id)
            expect(tracker).to respond_to(:conversation_name)
            expect(tracker).to respond_to(:can_share)
            puts "✅ Tracker structure validated"
            puts "📊 Sample tracker: #{tracker.name} (ID: #{tracker.id})"
            puts "📅 Last submission: #{Time.at(tracker.last_submission_date.to_i).strftime('%Y-%m-%d %H:%M:%S')}"
            puts "📌 Is pinned: #{tracker.is_pinned} | Can share: #{tracker.can_share}"
            puts "💬 Conversation: #{tracker.conversation_name} (ID: #{tracker.conversation_id})"
            puts "🔗 MLink: #{tracker.mlink[0..50]}..."

            # Test tracker icon info
            if tracker.tracker_icon_info
              expect(tracker.tracker_icon_info).to respond_to(:color_code)
              expect(tracker.tracker_icon_info).to respond_to(:icon_url)
              puts "✅ Tracker icon info validated"
              puts "🎨 Color: #{tracker.tracker_icon_info.color_code} | Icon: #{tracker.tracker_icon_info.icon_url}"
            end

            # Test transaction_id
            if response.respond_to?(:transaction_id)
              puts "✅ Transaction ID: #{response.transaction_id || 'None'}"
            end
          else
            puts "📊 Trackers list is empty"
          end
        else
          puts "📊 Trackers data not found"
        end

        expect(response).to respond_to(:trackers)
        puts "✅ Response structure validated"
      end
    end
  end
end
