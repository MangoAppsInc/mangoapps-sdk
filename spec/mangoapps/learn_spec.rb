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

  describe "My Learning" do
    it "gets user's learning progress and courses" do
      puts "\n🎓 Testing Learn API - My Learning..."
      
      response = client.my_learning
      
      expect(response).to be_a(MangoApps::Response) # Learn API returns wrapped response
      expect(response).to respond_to(:user_id)
      expect(response).to respond_to(:user_name)
      expect(response).to respond_to(:total_training_time)
      expect(response).to respond_to(:ongoing_course_count)
      expect(response).to respond_to(:completed_course_count)
      expect(response).to respond_to(:registered_course_count)
      expect(response).to respond_to(:section)
      expect(response.section).to be_an(Array)
      puts "✅ My Learning API call successful!"
      puts "📊 Response contains user learning data"
      
      # Validate the user learning structure using dot notation
      expect(response.user_id).to be_a(Integer)
      expect(response.user_name).to be_a(String)
      expect(response.total_training_time).to be_a(String)
      expect(response.ongoing_course_count).to be_a(Integer)
      expect(response.completed_course_count).to be_a(Integer)
      expect(response.registered_course_count).to be_a(Integer)
      puts "✅ My Learning structure validated"
      puts "👤 User: #{response.user_name} (ID: #{response.user_id})"
      puts "⏱️ Total training time: #{response.total_training_time}"
      puts "📚 Ongoing courses: #{response.ongoing_course_count}"
      puts "✅ Completed courses: #{response.completed_course_count}"
      puts "📝 Registered courses: #{response.registered_course_count}"
      
      # Validate sections structure
      if response.section.any?
        section = response.section.first
        expect(section).to respond_to(:key)
        expect(section).to respond_to(:label)
        expect(section).to respond_to(:count)
        expect(section).to respond_to(:courses)
        expect(section.courses).to be_an(Array)
        puts "✅ Learning sections structure validated"
        puts "📊 Found #{response.section.length} learning sections"
        puts "📂 Sample section: #{section.label} - #{section.count} courses"
        
        # If there are courses in the section, validate course structure
        if section.courses.any?
          course = section.courses.first
          expect(course).to respond_to(:id)
          expect(course).to respond_to(:name)
          expect(course).to respond_to(:course_type)
          expect(course).to respond_to(:delivery_mode)
          expect(course).to respond_to(:course_progress)
          puts "✅ Course structure in section validated"
          puts "📚 Sample course: #{course.name} (ID: #{course.id}) - #{course.course_progress}% progress"
        end
      else
        puts "📊 No learning sections found"
      end
    end
  end

end
