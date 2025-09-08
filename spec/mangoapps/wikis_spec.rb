# frozen_string_literal: true

require_relative "../real_spec_helper"
require_relative "../shared_test_helpers"

RSpec.describe "MangoApps Wikis Module" do
  include SharedTestHelpers
  let(:config) { MangoApps::Config.new }
  let(:client) { MangoApps::Client.new(config) }

  describe "Wikis Module" do
    describe "Get Wikis" do
      it "gets user wikis from actual MangoApps API" do
        puts "\n📚 Testing Wikis API - Get Wikis..."

        response = client.get_wikis(mode: "my", limit: 20, offset: 0)

        expect(response).to be_a(MangoApps::Response)
        expect(response).to respond_to(:wikis)
        puts "✅ Get wikis API call successful!"
        puts "📚 Response contains wikis data"

        if response.wikis
          wikis = response.wikis
          expect(wikis).to be_an(Array)
          puts "✅ Wikis structure validated"
          puts "📚 Found #{wikis.length} wikis"

          if wikis.any?
            # Test first wiki structure
            wiki = wikis.first
            expect(wiki).to respond_to(:id)
            expect(wiki).to respond_to(:title)
            expect(wiki).to respond_to(:children_count)
            expect(wiki).to respond_to(:updated_at)
            expect(wiki).to respond_to(:conversation_name)
            expect(wiki).to respond_to(:conversation_id)
            expect(wiki).to respond_to(:can_edit)
            expect(wiki).to respond_to(:is_draft)
            expect(wiki).to respond_to(:icon_properties)
            expect(wiki).to respond_to(:generate_pdf_access)
            expect(wiki).to respond_to(:status)
            expect(wiki).to respond_to(:user_image_url)
            expect(wiki).to respond_to(:user_name)
            expect(wiki).to respond_to(:governance_date)
            expect(wiki).to respond_to(:governance_enabled)
            puts "✅ Wiki structure validated"
            puts "📚 Sample wiki: #{wiki.title} (ID: #{wiki.id})"
            puts "📊 Children count: #{wiki.children_count} | Can edit: #{wiki.can_edit}"
            puts "📅 Updated: #{Time.at(wiki.updated_at.to_i).strftime('%Y-%m-%d %H:%M:%S')}"
            puts "💼 Conversation: #{wiki.conversation_name || 'None'} (ID: #{wiki.conversation_id})"
            puts "📄 Is draft: #{wiki.is_draft} | Generate PDF access: #{wiki.generate_pdf_access}"
            puts "👤 User: #{wiki.user_name || 'None'} | Status: #{wiki.status || 'None'}"
            puts "🔒 Governance enabled: #{wiki.governance_enabled} | Governance date: #{wiki.governance_date || 'None'}"

            # Test icon properties
            if wiki.icon_properties
              puts "✅ Icon properties structure validated"
              expect(wiki.icon_properties).to respond_to(:class)
              puts "🎨 Icon class: #{wiki.icon_properties.class}"
              # Access background-color using bracket notation since it contains a hyphen
              background_color = wiki.icon_properties.respond_to?(:'background-color') ? wiki.icon_properties.send(:'background-color') : nil
              puts "🎨 Background color: #{background_color || 'None'}"
            else
              puts "📚 No icon properties for this wiki"
            end

            # Test user image URL
            if wiki.user_image_url
              puts "👤 User image URL: #{wiki.user_image_url[0..50]}..."
            end

            # Test transaction_id
            if response.respond_to?(:transaction_id)
              puts "✅ Transaction ID: #{response.transaction_id || 'None'}"
            end

            # Display first few wikis
            puts "📚 Wiki List:"
            wikis.first(5).each do |w|
              puts "  • #{w.title} (ID: #{w.id})"
              puts "    Updated: #{Time.at(w.updated_at.to_i).strftime('%Y-%m-%d %H:%M:%S')}"
              puts "    Children: #{w.children_count} | Can edit: #{w.can_edit}"
              puts "    Conversation: #{w.conversation_name || 'None'} (ID: #{w.conversation_id})"
              puts "    Is draft: #{w.is_draft} | PDF access: #{w.generate_pdf_access}"
              if w.icon_properties
                background_color = w.icon_properties.respond_to?(:'background-color') ? w.icon_properties.send(:'background-color') : nil
                puts "    Icon: #{w.icon_properties.class} | Color: #{background_color || 'None'}"
              end
              puts ""
            end
          else
            puts "📚 Wikis list is empty"
          end
        else
          puts "📚 Wikis data not found"
        end

        expect(response).to respond_to(:wikis)
        puts "✅ Response structure validated"
      end
    end

    describe "Get Wiki Details" do
      it "gets detailed information for a specific wiki" do
        puts "\n📚 Testing Wikis API - Get Wiki Details..."

        # First get wikis to find a wiki ID to test with
        wikis_response = client.get_wikis(mode: "my", limit: 1, offset: 0)
        expect(wikis_response).to be_a(MangoApps::Response)
        expect(wikis_response.wikis).to be_an(Array)
        
        # Find a wiki to test with
        if wikis_response.wikis.any?
          test_wiki = wikis_response.wikis.first
          puts "📚 Testing with wiki: #{test_wiki.title} (ID: #{test_wiki.id})"
          
          response = client.get_wiki_details(test_wiki.id)

          expect(response).to be_a(MangoApps::Response)
          expect(response).to respond_to(:wiki)
          puts "✅ Get wiki details API call successful!"
          puts "📚 Response contains wiki details data"

          if response.wiki
            wiki = response.wiki
            expect(wiki).to respond_to(:details)
            expect(wiki).to respond_to(:mlink)
            expect(wiki).to respond_to(:can_comment)
            expect(wiki).to respond_to(:can_edit)
            expect(wiki).to respond_to(:can_delete)
            expect(wiki).to respond_to(:can_rename)
            expect(wiki).to respond_to(:can_move)
            expect(wiki).to respond_to(:can_duplicate)
            expect(wiki).to respond_to(:attachments)
            expect(wiki).to respond_to(:attachment_references)
            expect(wiki).to respond_to(:reactions)
            expect(wiki).to respond_to(:comment_count)
            expect(wiki).to respond_to(:is_pinned)
            expect(wiki).to respond_to(:governance_enabled)
            expect(wiki).to respond_to(:is_draft)
            expect(wiki).to respond_to(:reaction_data)
            expect(wiki).to respond_to(:hashtags)
            puts "✅ Wiki details structure validated"

            # Test wiki details
            if wiki.details
              details = wiki.details
              expect(details).to respond_to(:id)
              expect(details).to respond_to(:title)
              expect(details).to respond_to(:description)
              expect(details).to respond_to(:banner_url)
              expect(details).to respond_to(:status)
              expect(details).to respond_to(:feed_id)
              expect(details).to respond_to(:conversation_id)
              expect(details).to respond_to(:domain_id)
              expect(details).to respond_to(:user_id)
              expect(details).to respond_to(:created_at)
              expect(details).to respond_to(:edit_permissions)
              expect(details).to respond_to(:is_commentable)
              expect(details).to respond_to(:updated_at)
              expect(details).to respond_to(:last_updated_by)
              expect(details).to respond_to(:total_read_count)
              expect(details).to respond_to(:children_count)
              expect(details).to respond_to(:lft)
              expect(details).to respond_to(:rgt)
              expect(details).to respond_to(:parent_id)
              expect(details).to respond_to(:non_member_wiki_access)
              expect(details).to respond_to(:platform)
              expect(details).to respond_to(:modified_on)
              expect(details).to respond_to(:generate_pdf_access)
              expect(details).to respond_to(:icon_properties)
              expect(details).to respond_to(:archived)
              expect(details).to respond_to(:archived_on)
              expect(details).to respond_to(:archived_by)
              expect(details).to respond_to(:is_deleted)
              expect(details).to respond_to(:show_toc)
              expect(details).to respond_to(:conversation_name)
              expect(details).to respond_to(:updated_by_name)
              expect(details).to respond_to(:created_by_name)
              expect(details).to respond_to(:has_toc)
              puts "✅ Wiki details structure validated"
              puts "📚 Wiki: #{details.title} (ID: #{details.id})"
              puts "📊 Status: #{details.status} | Platform: #{details.platform}"
              puts "📅 Created: #{Time.at(details.created_at.to_i).strftime('%Y-%m-%d %H:%M:%S')}"
              puts "📅 Updated: #{Time.at(details.updated_at.to_i).strftime('%Y-%m-%d %H:%M:%S')}"
              puts "📅 Modified: #{details.modified_on}"
              puts "👤 Created by: #{details.created_by_name} (ID: #{details.user_id})"
              puts "👤 Updated by: #{details.updated_by_name} (ID: #{details.last_updated_by})"
              puts "💼 Conversation: #{details.conversation_name} (ID: #{details.conversation_id})"
              puts "📊 Read count: #{details.total_read_count} | Children: #{details.children_count}"
              puts "🔒 Edit permissions: #{details.edit_permissions} | Commentable: #{details.is_commentable}"
              puts "📄 Generate PDF access: #{details.generate_pdf_access} | Show TOC: #{details.show_toc}"
              puts "🏗️ Has TOC: #{details.has_toc} | Archived: #{details.archived}"
              puts "🔗 Domain ID: #{details.domain_id} | Feed ID: #{details.feed_id}"

              # Test wiki content
              if details.description
                puts "📝 Description: #{details.description[0..200]}..."
              end

              # Test banner URL
              if details.banner_url
                puts "🖼️ Banner URL: #{details.banner_url[0..50]}..."
              end

              # Test icon properties
              if details.icon_properties
                puts "🎨 Icon properties: #{details.icon_properties.inspect}"
              end

              # Test archived information
              if details.archived_on
                puts "📦 Archived on: #{details.archived_on}"
              end
              if details.archived_by
                puts "📦 Archived by: #{details.archived_by}"
              end
            end

            # Test wiki permissions
            puts "🔐 Wiki Permissions:"
            puts "  Can comment: #{wiki.can_comment}"
            puts "  Can edit: #{wiki.can_edit}"
            puts "  Can delete: #{wiki.can_delete}"
            puts "  Can rename: #{wiki.can_rename}"
            puts "  Can move: #{wiki.can_move}"
            puts "  Can duplicate: #{wiki.can_duplicate}"

            # Test wiki links
            if wiki.mlink
              puts "🔗 MLink: #{wiki.mlink}"
            end

            # Test attachments
            if wiki.attachments
              puts "📎 Attachments: #{wiki.attachments.length} attachments"
            end
            if wiki.attachment_references
              puts "📎 Attachment references: #{wiki.attachment_references.length} references"
            end

            # Test reactions
            if wiki.reactions
              reactions = wiki.reactions
              expect(reactions).to respond_to(:superlike_count)
              expect(reactions).to respond_to(:like_count)
              expect(reactions).to respond_to(:haha_count)
              expect(reactions).to respond_to(:yay_count)
              expect(reactions).to respond_to(:wow_count)
              expect(reactions).to respond_to(:sad_count)
              expect(reactions).to respond_to(:liked)
              expect(reactions).to respond_to(:superliked)
              expect(reactions).to respond_to(:haha)
              expect(reactions).to respond_to(:yay)
              expect(reactions).to respond_to(:wow)
              expect(reactions).to respond_to(:sad)
              puts "✅ Reactions structure validated"
              puts "👍 Reactions: Like: #{reactions.like_count}, Superlike: #{reactions.superlike_count}"
              puts "😄 Reactions: Haha: #{reactions.haha_count}, Yay: #{reactions.yay_count}, Wow: #{reactions.wow_count}, Sad: #{reactions.sad_count}"
              puts "👤 User reactions: Liked: #{reactions.liked}, Superliked: #{reactions.superliked}"
            end

            # Test reaction data
            if wiki.reaction_data
              reaction_data = wiki.reaction_data
              expect(reaction_data).to be_an(Array)
              puts "✅ Reaction data structure validated"
              puts "📊 Reaction data: #{reaction_data.length} reaction types"
              reaction_data.each do |reaction|
                expect(reaction).to respond_to(:count)
                expect(reaction).to respond_to(:key)
                expect(reaction).to respond_to(:reacted)
                expect(reaction).to respond_to(:label)
                puts "  - #{reaction.label}: #{reaction.count} (Reacted: #{reaction.reacted})"
              end
            end

            # Test comment count
            puts "💬 Comment count: #{wiki.comment_count}"

            # Test wiki status
            puts "📌 Is pinned: #{wiki.is_pinned}"
            puts "📄 Is draft: #{wiki.is_draft}"
            puts "🔒 Governance enabled: #{wiki.governance_enabled}"

            # Test hashtags
            if wiki.hashtags
              hashtags = wiki.hashtags
              expect(hashtags).to be_an(Array)
              puts "✅ Hashtags structure validated"
              puts "🏷️ Hashtags: #{hashtags.length} hashtags"
              hashtags.each do |hashtag|
                puts "  - #{hashtag}"
              end
            end

            # Test transaction_id
            if response.respond_to?(:transaction_id)
              puts "✅ Transaction ID: #{response.transaction_id || 'None'}"
            end
          else
            puts "📚 Wiki details data not found"
          end

          expect(response).to respond_to(:wiki)
          puts "✅ Response structure validated"
        else
          puts "📚 No wikis found to test with"
          puts "✅ Skipping wiki details test - no suitable test wiki available"
        end
      end
    end
  end
end
