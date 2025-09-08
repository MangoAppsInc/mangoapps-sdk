# frozen_string_literal: true

require_relative "../real_spec_helper"
require_relative "../shared_test_helpers"

RSpec.describe "MangoApps Libraries Module" do
  include SharedTestHelpers
  let(:config) { MangoApps::Config.new }
  let(:client) { MangoApps::Client.new(config) }

  describe "Libraries Module" do
    describe "Get Libraries" do
      it "gets user libraries from actual MangoApps API" do
        puts "\n📚 Testing Libraries API - Get Libraries..."

        response = client.get_libraries

        expect(response).to be_a(MangoApps::Response)
        expect(response).to respond_to(:libraries)
        puts "✅ Get libraries API call successful!"
        puts "📊 Response contains libraries data"

        if response.libraries
          libraries = response.libraries
          expect(libraries).to be_an(Array)
          puts "✅ Libraries structure validated"
          puts "📚 Found #{libraries.length} libraries"

          if libraries.any?
            library = libraries.first
            expect(library).to respond_to(:id)
            expect(library).to respond_to(:name)
            expect(library).to respond_to(:library_type)
            expect(library).to respond_to(:view_mode)
            expect(library).to respond_to(:description)
            expect(library).to respond_to(:edit_access)
            expect(library).to respond_to(:position)
            expect(library).to respond_to(:total_items_count)
            expect(library).to respond_to(:categories)
            puts "✅ Library structure validated"
            puts "📚 Sample library: #{library.name} (ID: #{library.id})"
            puts "📝 Type: #{library.library_type} | View: #{library.view_mode}"
            puts "📊 Items: #{library.total_items_count} | Categories: #{library.categories.length}"
            puts "🔧 Edit access: #{library.edit_access} | Position: #{library.position}"

            # Test library properties
            expect(library).to respond_to(:enable_icon_color)
            expect(library).to respond_to(:enable_icon_color_for_categories)
            expect(library).to respond_to(:banner_image_url)
            expect(library).to respond_to(:banner_color)
            expect(library).to respond_to(:icon_properties)
            expect(library).to respond_to(:governance_enabled)
            expect(library).to respond_to(:can_add)
            expect(library).to respond_to(:created_at)
            expect(library).to respond_to(:updated_at)
            puts "✅ Library properties validated"
            puts "🎨 Banner color: #{library.banner_color} | Icon color enabled: #{library.enable_icon_color}"
            puts "📅 Created: #{Time.at(library.created_at.to_i).strftime('%Y-%m-%d %H:%M:%S')}"
            puts "📅 Updated: #{Time.at(library.updated_at.to_i).strftime('%Y-%m-%d %H:%M:%S')}"

            # Test icon properties
            if library.icon_properties
              expect(library.icon_properties).to respond_to(:color)
              expect(library.icon_properties).to respond_to(:class)
              puts "✅ Icon properties validated"
              puts "🎨 Icon color: #{library.icon_properties.color} | Icon class: #{library.icon_properties.class}"
            end

            # Test categories
            if library.categories && library.categories.any?
              category = library.categories.first
              expect(category).to respond_to(:id)
              expect(category).to respond_to(:rank)
              expect(category).to respond_to(:name)
              expect(category).to respond_to(:description)
              expect(category).to respond_to(:is_system)
              expect(category).to respond_to(:icon)
              expect(category).to respond_to(:library_items_count)
              puts "✅ Category structure validated"
              puts "📁 Sample category: #{category.name} (ID: #{category.id})"
              puts "📊 Items: #{category.library_items_count} | Rank: #{category.rank}"
              puts "🔧 Is system: #{category.is_system} | Icon: #{category.icon || 'None'}"
            end
          else
            puts "📊 Libraries list is empty"
          end
        else
          puts "📊 Libraries data not found"
        end

        expect(response).to respond_to(:libraries)
        puts "✅ Response structure validated"
      end
    end
  end
end
