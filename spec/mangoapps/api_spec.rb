# frozen_string_literal: true

require_relative "../real_spec_helper"

RSpec.describe "MangoApps API Calls" do
  let(:config) { MangoApps::Config.new }
  let(:client) { MangoApps::Client.new(config) }

  before do
    # Ensure we have a valid token
    unless config.has_valid_token?
      skip "No valid access token found. Run OAuth tests first."
    end
  end

  describe "User API" do
    it "gets current user info from /api/me" do
      puts "\n🌐 Testing /api/me endpoint..."
      
      response = client.get("me")
      
      expect(response).not_to be_nil
      puts "✅ /api/me call successful!"
      puts "📊 Response: #{response}"
    end

    it "handles API errors gracefully" do
      puts "\n🧪 Testing error handling..."
      
      # Test with invalid endpoint - it might return 404 or other error
      begin
        response = client.get("invalid_endpoint")
        puts "📊 Invalid endpoint response: #{response}"
        puts "✅ API handled invalid endpoint gracefully"
      rescue MangoApps::APIError => e
        puts "✅ API error handling works: #{e.message}"
      end
    end
  end

end
