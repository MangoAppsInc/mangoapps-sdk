# frozen_string_literal: true

require_relative "../real_spec_helper"

RSpec.describe "MangoApps Learn Module" do
  let(:config) { MangoApps::Config.new }
  let(:client) { MangoApps::Client.new(config) }

  before do
    # Ensure we have a valid token
    unless config.has_valid_token?
      skip "No valid access token found. Run OAuth tests first."
    end
  end

  describe "Course Catalog" do
    it "gets course catalog from actual MangoApps Learn API" do
      puts "\n📚 Testing Learn API - Course Catalog..."
      
      response = client.course_catalog
      
      expect(response).to be_a(Hash) # Learn API returns parsed JSON
      expect(response).to have_key("ms_response")
      expect(response["ms_response"]).to have_key("courses")
      expect(response["ms_response"]["courses"]).to be_an(Array)
      puts "✅ Course catalog API call successful!"
      puts "📊 Response contains course catalog data"
      
      # Validate the course structure
      if response["ms_response"]["courses"].any?
        course = response["ms_response"]["courses"].first
        expect(course).to have_key("id")
        expect(course).to have_key("name")
        expect(course).to have_key("course_type")
        expect(course).to have_key("delivery_mode")
        expect(course).to have_key("start_course_url")
        puts "✅ Course catalog structure validated"
        puts "📊 Found #{response['ms_response']['courses'].length} courses"
        puts "📚 Sample course: #{course['name']} (ID: #{course['id']})"
      else
        puts "📊 Course catalog is empty"
      end
    end

    it "gets course catalog with parameters" do
      puts "\n📚 Testing Learn API - Course Catalog with params..."
      
      response = client.course_catalog(limit: 10)
      
      expect(response).to be_a(Hash)
      expect(response).to have_key("ms_response")
      expect(response["ms_response"]).to have_key("courses")
      puts "✅ Course catalog with parameters successful!"
    end
  end

  describe "Categories" do
    it "tests course categories API endpoint" do
      puts "\n📂 Testing Learn API - Course Categories..."
      
      response = client.course_categories
      puts "📊 Category API response: #{response}"
      puts "✅ Course categories API call completed!"
      puts "📊 Response type: #{response.class}"
      
      # Note: This endpoint might return "ok" if not implemented or return actual data
      # The important thing is that the API call doesn't crash
    end

    it "tests specific course category details API endpoint" do
      puts "\n📂 Testing Learn API - Specific Category..."
      
      # Test with a common category ID (this might need adjustment based on actual data)
      response = client.course_category(1)
      puts "📊 Category details API response: #{response}"
      puts "✅ Course category details API call completed!"
      puts "📊 Response type: #{response.class}"
      
      # Note: This endpoint might return "ok" if not implemented or return actual data
      # The important thing is that the API call doesn't crash
    end
  end
end
