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
  end
end
