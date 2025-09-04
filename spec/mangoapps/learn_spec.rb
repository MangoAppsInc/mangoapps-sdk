# frozen_string_literal: true

require_relative "../real_spec_helper"
require_relative "../shared_test_helpers"

RSpec.describe "MangoApps Learn Module" do
  include SharedTestHelpers
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
      
      expect(response).to be_a(MangoApps::Response) # Learn API returns wrapped response
      expect(response).to respond_to(:courses)
      expect(response.courses).to be_an(Array)
      puts "✅ Course catalog API call successful!"
      puts "📊 Response contains course catalog data"
      
      # Validate the course structure using dot notation
      if response.courses.any?
        course = response.courses.first
        expect(course).to respond_to(:id)
        expect(course).to respond_to(:name)
        expect(course).to respond_to(:course_type)
        expect(course).to respond_to(:delivery_mode)
        expect(course).to respond_to(:start_course_url)
        puts "✅ Course catalog structure validated"
        puts "📊 Found #{response.courses.length} courses"
        puts "📚 Sample course: #{course.name} (ID: #{course.id})"
      else
        puts "📊 Course catalog is empty"
      end
    end
  end

  describe "Course Categories" do
    it "gets course categories" do
      puts "\n📂 Testing Learn API - Course Categories..."
      
      response = client.course_categories
      
      expect(response).to be_a(MangoApps::Response) # Learn API returns wrapped response
      expect(response).to respond_to(:all_categories)
      expect(response.all_categories).to be_an(Array)
      puts "✅ Course categories API call successful!"
      puts "📊 Response contains course categories data"
      
      # Validate the category structure using dot notation
      if response.all_categories.any?
        category = response.all_categories.first
        expect(category).to respond_to(:id)
        expect(category).to respond_to(:name)
        expect(category).to respond_to(:icon_properties)
        expect(category).to respond_to(:position)
        puts "✅ Course categories structure validated"
        puts "📊 Found #{response.all_categories.length} categories"
        puts "📂 Sample category: #{category.name} (ID: #{category.id})"
      else
        puts "📊 Course categories list is empty"
      end
    end

  end
end
