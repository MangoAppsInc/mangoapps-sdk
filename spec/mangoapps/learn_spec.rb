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
    it "gets course catalog" do
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
  end

  describe "Course Categories" do
    it "gets course categories" do
      puts "\n📂 Testing Learn API - Course Categories..."
      
      response = client.course_categories
      
      expect(response).to be_a(Hash) # Learn API returns parsed JSON
      expect(response).to have_key("ms_response")
      expect(response["ms_response"]).to have_key("all_categories")
      expect(response["ms_response"]["all_categories"]).to be_an(Array)
      puts "✅ Course categories API call successful!"
      puts "📊 Response contains course categories data"
      
      # Validate the category structure
      if response["ms_response"]["all_categories"].any?
        category = response["ms_response"]["all_categories"].first
        expect(category).to have_key("id")
        expect(category).to have_key("name")
        expect(category).to have_key("icon_properties")
        expect(category).to have_key("position")
        puts "✅ Course categories structure validated"
        puts "📊 Found #{response['ms_response']['all_categories'].length} categories"
        puts "📂 Sample category: #{category['name']} (ID: #{category['id']})"
      else
        puts "📊 Course categories list is empty"
      end
    end

  end
end
