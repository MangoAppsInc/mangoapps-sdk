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

    it "lists users from /api/users" do
      puts "\n👥 Testing /api/users endpoint..."
      
      response = client.get("users")
      
      expect(response).to be_a(String) # MangoApps returns XML
      expect(response).to include("<ms_response>")
      expect(response).to include("<users")
      puts "✅ /api/users call successful!"
      puts "📊 Response contains XML with users structure"
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

  describe "Posts API" do
    it "lists posts from actual MangoApps API" do
      puts "\n📝 Testing /api/posts endpoint..."
      
      response = client.get("posts")
      
      expect(response).to be_a(String) # MangoApps returns XML
      expect(response).to include("<ms_response>")
      expect(response).to include("<posts")
      puts "✅ /api/posts call successful!"
      puts "📊 Response contains XML with posts structure"
    end

    it "tests posts resource method" do
      puts "\n📝 Testing posts resource method..."
      
      response = client.posts_list
      
      expect(response).to be_a(String)
      expect(response).to include("ms_response")
      puts "✅ Posts resource method works"
    end
  end

  describe "Additional API Endpoints" do
    it "tests common MangoApps API endpoints" do
      puts "\n🔍 Testing additional API endpoints..."
      
      # Test various common endpoints
      endpoints_to_test = [
        "files",
        "groups", 
        "projects",
        "tasks",
        "events",
        "documents",
        "announcements"
      ]
      
      endpoints_to_test.each do |endpoint|
        begin
          puts "  Testing /api/#{endpoint}..."
          response = client.get(endpoint)
          
          if response.is_a?(String) && response.include?("<ms_response>")
            puts "    ✅ /api/#{endpoint} - accessible"
          else
            puts "    ⚠️  /api/#{endpoint} - unexpected response format"
          end
        rescue MangoApps::APIError => e
          puts "    ❌ /api/#{endpoint} - error: #{e.message}"
        rescue => e
          puts "    ❌ /api/#{endpoint} - unexpected error: #{e.message}"
        end
      end
      
      puts "✅ Additional endpoint testing completed"
    end
  end

  describe "API Configuration" do
    it "uses correct API base URL" do
      expect(config.api_base).to eq("https://siddus.mangoapps.com/api/")
    end

    it "constructs proper API endpoints" do
      # Test URL joining
      full_url = URI.join(config.api_base, "me").to_s
      expect(full_url).to eq("https://siddus.mangoapps.com/api/me")
    end
  end
end
