# frozen_string_literal: true

require_relative "../real_spec_helper"
require_relative "../shared_test_helpers"

RSpec.describe "MangoApps Attachments Module" do
  include SharedTestHelpers
  let(:config) { MangoApps::Config.new }
  let(:client) { MangoApps::Client.new(config) }

  describe "Attachments Module" do
    describe "Get Folders" do
      it "gets user folders from actual MangoApps API" do
        puts "\n📁 Testing Attachments API - Get Folders..."

        response = client.get_folders

        expect(response).to be_a(MangoApps::Response)
        expect(response).to respond_to(:folders)
        puts "✅ Get folders API call successful!"
        puts "📁 Response contains folders data"

        if response.folders
          folders = response.folders
          expect(folders).to be_an(Array)
          puts "✅ Folders structure validated"
          puts "📁 Found #{folders.length} folders"

          if folders.any?
            folder = folders.first
            expect(folder).to respond_to(:id)
            expect(folder).to respond_to(:name)
            expect(folder).to respond_to(:relativePath)
            expect(folder).to respond_to(:folder_rel)
            expect(folder).to respond_to(:is_virtual_folder)
            expect(folder).to respond_to(:updated_at)
            expect(folder).to respond_to(:child_count)
            expect(folder).to respond_to(:show_permission_options)
            expect(folder).to respond_to(:show_apply_parent_option)
            expect(folder).to respond_to(:can_save)
            expect(folder).to respond_to(:is_pinned)
            expect(folder).to respond_to(:folder_type_from_db)
            expect(folder).to respond_to(:show_in_upload)
            expect(folder).to respond_to(:show_in_move)
            expect(folder).to respond_to(:filter)
            puts "✅ Folder structure validated"
            puts "📁 Sample folder: #{folder.name} (ID: #{folder.id})"
            puts "📂 Relative path: #{folder.relativePath}"
            puts "📊 Child count: #{folder.child_count} | Can save: #{folder.can_save}"
            puts "📌 Is pinned: #{folder.is_pinned} | Is virtual: #{folder.is_virtual_folder}"
            puts "🔧 Folder rel: #{folder.folder_rel} | Type: #{folder.folder_type_from_db || 'None'}"
            puts "⚙️ Show in upload: #{folder.show_in_upload} | Show in move: #{folder.show_in_move}"
            puts "🔍 Filter: #{folder.filter} | Show permissions: #{folder.show_permission_options}"

            # Test conversation_id and user_id (can be null)
            if folder.respond_to?(:conversation_id)
              puts "💬 Conversation ID: #{folder.conversation_id || 'None'}"
            end
            if folder.respond_to?(:user_id)
              puts "👤 User ID: #{folder.user_id || 'None'}"
            end

            # Test transaction_id
            if response.respond_to?(:transaction_id)
              puts "✅ Transaction ID: #{response.transaction_id || 'None'}"
            end
          else
            puts "📁 Folders list is empty"
          end
        else
          puts "📁 Folders data not found"
        end

        expect(response).to respond_to(:folders)
        puts "✅ Response structure validated"
      end
    end

    describe "Get Folder Files" do
      it "gets files and folders from a specific folder" do
        puts "\n📁 Testing Attachments API - Get Folder Files..."

        # First get folders to find a folder ID to test with
        folders_response = client.get_folders
        expect(folders_response).to be_a(MangoApps::Response)
        expect(folders_response.folders).to be_an(Array)
        
        # Find a folder with child_count > 0 to test with
        test_folder = folders_response.folders.find { |f| f.child_count.to_i > 0 }
        
        if test_folder
          puts "📁 Testing with folder: #{test_folder.name} (ID: #{test_folder.id})"
          
          response = client.get_folder_files(test_folder.id, include_folders: "Y")

          expect(response).to be_a(MangoApps::Response)
          expect(response).to respond_to(:files)
          puts "✅ Get folder files API call successful!"
          puts "📁 Response contains folder files data"

          expect(response).to respond_to(:total_count)
          expect(response).to respond_to(:name)
          expect(response).to respond_to(:role_name)
          puts "✅ Folder files structure validated"
          puts "📁 Folder name: #{response.name}"
          puts "📊 Total count: #{response.total_count}"
          puts "👤 Role: #{response.role_name}"

          # Test domain suspension status
          if response.respond_to?(:is_domain_suspended)
            puts "🔒 Domain suspended: #{response.is_domain_suspended}"
          end

          # Test show in upload
          if response.respond_to?(:show_in_upload)
            puts "📤 Show in upload: #{response.show_in_upload}"
          end

          # Test transaction_id
          if response.respond_to?(:transaction_id)
            puts "✅ Transaction ID: #{response.transaction_id || 'None'}"
          end

          # Test files array
          if response.files && response.files.any?
            files = response.files
            expect(files).to be_an(Array)
            puts "📁 Found #{files.length} files/folders"

            # Test first file/folder structure
            file = files.first
            expect(file).to respond_to(:id)
            expect(file).to respond_to(:filename)
            expect(file).to respond_to(:parent_id)
            expect(file).to respond_to(:is_liked)
            expect(file).to respond_to(:like_count)
            expect(file).to respond_to(:has_activity)
            expect(file).to respond_to(:visibility)
            expect(file).to respond_to(:relativePath)
            expect(file).to respond_to(:size)
            expect(file).to respond_to(:is_pinned)
            expect(file).to respond_to(:updated_at)
            expect(file).to respond_to(:user_id)
            expect(file).to respond_to(:uploader_name)
            expect(file).to respond_to(:is_folder)
            expect(file).to respond_to(:can_save)
            expect(file).to respond_to(:show_permission_options)
            expect(file).to respond_to(:show_apply_parent_option)
            puts "✅ File/folder structure validated"
            puts "📁 Sample item: #{file.filename} (ID: #{file.id})"
            puts "📂 Is folder: #{file.is_folder} | Size: #{file.size} bytes"
            puts "👤 Uploader: #{file.uploader_name} (ID: #{file.user_id})"
            puts "📅 Updated: #{Time.at(file.updated_at.to_i).strftime('%Y-%m-%d %H:%M:%S')}"
            puts "🔒 Visibility: #{file.visibility} | Privacy: #{file.privacy_type}"
            puts "📌 Is pinned: #{file.is_pinned} | Is liked: #{file.is_liked}"
            puts "💾 Can save: #{file.can_save} | Show permissions: #{file.show_permission_options}"

            # Test role permissions
            if file.role
              expect(file.role).to respond_to(:can_edit)
              expect(file.role).to respond_to(:can_share)
              expect(file.role).to respond_to(:can_restore)
              puts "✅ Role permissions validated"
              puts "🔧 Can edit: #{file.role.can_edit} | Can share: #{file.role.can_share} | Can restore: #{file.role.can_restore}"
            end

            # Test links
            if file.respond_to?(:mLink)
              puts "🔗 MLink: #{file.mLink[0..50]}..."
            end
            if file.respond_to?(:internal_link)
              puts "🔗 Internal link: #{file.internal_link[0..50]}..."
            end

            # Test additional properties
            if file.respond_to?(:followers_count)
              puts "👥 Followers: #{file.followers_count}"
            end
            if file.respond_to?(:governance_enabled)
              puts "🛡️ Governance enabled: #{file.governance_enabled}"
            end
          else
            puts "📁 No files/folders found in this folder"
          end

          expect(response).to respond_to(:files)
          puts "✅ Response structure validated"
        else
          puts "📁 No folders with content found to test with"
          puts "✅ Skipping folder files test - no suitable test folder available"
        end
      end
    end
  end
end
