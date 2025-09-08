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

    describe "Get Library Categories" do
      it "gets library categories by library ID from actual MangoApps API" do
        puts "\n📚 Testing Libraries API - Get Library Categories..."

        library_id = 9776  # Frequently Used Forms library
        response = client.get_library_categories(library_id)

        expect(response).to be_a(MangoApps::Response)
        expect(response).to respond_to(:library)
        puts "✅ Get library categories API call successful!"
        puts "📊 Response contains library categories data"

        if response.library
          library = response.library
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
          puts "📚 Library: #{library.name} (ID: #{library.id})"
          puts "📝 Type: #{library.library_type} | View: #{library.view_mode}"
          puts "📊 Total items: #{library.total_items_count} | Categories: #{library.categories.length}"
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
            categories = library.categories
            expect(categories).to be_an(Array)
            puts "✅ Categories structure validated"
            puts "📁 Found #{categories.length} categories"

            categories.each do |category|
              expect(category).to respond_to(:id)
              expect(category).to respond_to(:rank)
              expect(category).to respond_to(:name)
              expect(category).to respond_to(:description)
              expect(category).to respond_to(:is_system)
              expect(category).to respond_to(:icon)
              expect(category).to respond_to(:library_items_count)
              puts "✅ Category structure validated"
              puts "📁 Category: #{category.name} (ID: #{category.id})"
              puts "📊 Items: #{category.library_items_count} | Rank: #{category.rank}"
              puts "🔧 Is system: #{category.is_system} | Icon: #{category.icon || 'None'}"
              if category.description
                puts "📝 Description: #{category.description[0..100]}..."
              end
            end
          else
            puts "📊 Categories list is empty"
          end
        else
          puts "📊 Library data not found"
        end

        expect(response).to respond_to(:library)
        puts "✅ Response structure validated"
      end
    end

    describe "Get Library Items" do
      it "gets library items by library ID and category ID from actual MangoApps API" do
        puts "\n📚 Testing Libraries API - Get Library Items..."

        library_id = 9776  # Frequently Used Forms library
        category_id = 50114  # India Office category
        response = client.get_library_items(library_id, category_id)

        expect(response).to be_a(MangoApps::Response)
        expect(response).to respond_to(:category_name)
        puts "✅ Get library items API call successful!"
        puts "📊 Response contains library items data"

        expect(response).to respond_to(:category_name)
        expect(response).to respond_to(:view_mode)
        expect(response).to respond_to(:enable_icon_color)
        expect(response).to respond_to(:library_type)
        expect(response).to respond_to(:library_id)
        expect(response).to respond_to(:can_add)
        expect(response).to respond_to(:library_items)
        puts "✅ Library items response structure validated"
        puts "📁 Category: #{response.category_name}"
        puts "📝 View mode: #{response.view_mode} | Library type: #{response.library_type}"
        puts "🔧 Library ID: #{response.library_id} | Can add: #{response.can_add}"
        puts "🎨 Icon color: #{response.enable_icon_color}"

        # Test library items
        if response.library_items && response.library_items.any?
          library_items = response.library_items
          expect(library_items).to be_an(Array)
          puts "✅ Library items structure validated"
          puts "📚 Found #{library_items.length} library items"

          library_items.each do |item|
            expect(item).to respond_to(:id)
            expect(item).to respond_to(:name)
            expect(item).to respond_to(:description)
            expect(item).to respond_to(:link_type)
            expect(item).to respond_to(:link)
            puts "✅ Library item structure validated"
            puts "📄 Item: #{item.name} (ID: #{item.id})"
            puts "🔗 Link type: #{item.link_type} | Link: #{item.link[0..50]}..."

            # Test item properties based on link type
            if item.link_type == "ExternalLink"
              expect(item).to respond_to(:icon_properties)
              if item.icon_properties
                expect(item.icon_properties).to respond_to(:color)
                expect(item.icon_properties).to respond_to(:class)
                puts "✅ External link icon properties validated"
                puts "🎨 Icon color: #{item.icon_properties.color} | Icon class: #{item.icon_properties.class}"
              end
            elsif item.link_type == "Attachment"
              expect(item).to respond_to(:color)
              expect(item).to respond_to(:image_url)
              expect(item).to respond_to(:preview_url)
              expect(item).to respond_to(:attachment_id)
              expect(item).to respond_to(:file_type)
              expect(item).to respond_to(:likes_count)
              expect(item).to respond_to(:is_liked)
              expect(item).to respond_to(:short_url)
              puts "✅ Attachment properties validated"
              puts "📎 Attachment ID: #{item.attachment_id} | File type: #{item.file_type}"
              puts "👍 Likes: #{item.likes_count} | Is liked: #{item.is_liked}"
              puts "🖼️ Image URL: #{item.image_url}"
              puts "🔗 Short URL: #{item.short_url[0..50]}..."
            end
          end
        else
          puts "📊 Library items list is empty"
        end

        expect(response).to respond_to(:library_items)
        puts "✅ Response structure validated"
      end
    end
  end
end
