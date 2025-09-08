# frozen_string_literal: true

require_relative "../real_spec_helper"
require_relative "../shared_test_helpers"

RSpec.describe "MangoApps Posts Module" do
  include SharedTestHelpers
  let(:config) { MangoApps::Config.new }
  let(:client) { MangoApps::Client.new(config) }

  describe "Posts Module" do
    describe "Get All Posts" do
      it "gets all posts from actual MangoApps API" do
        puts "\n📝 Testing Posts API - Get All Posts..."
        
        response = client.get_all_posts(filter_by: "all")
        
        expect(response).to be_a(MangoApps::Response)
        expect(response).to respond_to(:feeds)
        expect(response).to respond_to(:post_view_count_visibility)
        expect(response).to respond_to(:post_view_count_link_config)
        puts "✅ Get all posts API call successful!"
        puts "📊 Response contains posts data"
        
        if response.feeds && response.feeds.any?
          post = response.feeds.first
          expect(post).to respond_to(:id)
          expect(post).to respond_to(:feed_type)
          expect(post).to respond_to(:body)
          expect(post).to respond_to(:from_user)
          expect(post).to respond_to(:feed_property)
          expect(post).to respond_to(:post_id)
          expect(post).to respond_to(:group_id)
          expect(post).to respond_to(:group_name)
          expect(post).to respond_to(:created_at)
          expect(post).to respond_to(:updated_at)
          expect(post).to respond_to(:tile)
          expect(post).to respond_to(:comments)
          puts "✅ Posts structure validated"
          puts "📊 Found #{response.feeds.length} posts"
          puts "📝 Sample post: #{post.tile.tile_name} (ID: #{post.id})"
          puts "👤 From: #{post.from_user.name} | Group: #{post.group_name}"
          puts "📅 Created: #{Time.at(post.created_at.to_i).strftime('%Y-%m-%d %H:%M:%S')}"
          puts "👀 View count: #{post.total_view_count}"
          
          if post.tile
            expect(post.tile).to respond_to(:tile_name)
            expect(post.tile).to respond_to(:tile_content)
            expect(post.tile).to respond_to(:tile_image)
            puts "✅ Tile structure validated"
            puts "📝 Tile: #{post.tile.tile_name}"
          end
          
          if post.comments && post.comments.any?
            comment = post.comments.first
            expect(comment).to respond_to(:id)
            expect(comment).to respond_to(:body)
            expect(comment).to respond_to(:user)
            expect(comment).to respond_to(:created_at)
            puts "✅ Comments structure validated"
            puts "💬 Found #{post.comments.length} comments"
            puts "💬 Sample comment: #{comment.body} by #{comment.user.name}"
          end
        else
          puts "📊 Posts list is empty"
        end
        
        expect(response).to respond_to(:post_view_count_visibility)
        expect(response).to respond_to(:post_view_count_link_config)
        puts "✅ Response structure validated"
        puts "📊 Post view count visibility: #{response.post_view_count_visibility}"
        puts "📊 Post view count link config: #{response.post_view_count_link_config}"
      end
    end

    describe "Get Post By ID" do
      it "gets post details by ID from actual MangoApps API" do
        puts "\n📝 Testing Posts API - Get Post By ID..."
        
        post_id = 59101  # Weekly Status 9/5 post
        response = client.get_post_by_id(post_id, full_description: "Y")
        
        expect(response).to be_a(MangoApps::Response)
        expect(response).to respond_to(:post)
        puts "✅ Get post by ID API call successful!"
        puts "📊 Response contains post details"
        
        if response.post
          post = response.post
          expect(post).to respond_to(:id)
          expect(post).to respond_to(:title)
          expect(post).to respond_to(:featured_image_url)
          expect(post).to respond_to(:stripped_description)
          expect(post).to respond_to(:tile)
          expect(post).to respond_to(:created_at)
          expect(post).to respond_to(:creator_by)
          expect(post).to respond_to(:created_name)
          expect(post).to respond_to(:conversation_name)
          expect(post).to respond_to(:total_view_count)
          expect(post).to respond_to(:like_count)
          expect(post).to respond_to(:comment_count)
          puts "✅ Post details structure validated"
          puts "📝 Post: #{post.title} (ID: #{post.id})"
          puts "👤 Created by: #{post.created_name} (ID: #{post.creator_by})"
          puts "📅 Created: #{Time.at(post.created_at.to_i).strftime('%Y-%m-%d %H:%M:%S')}"
          puts "👀 View count: #{post.total_view_count} | Likes: #{post.like_count} | Comments: #{post.comment_count}"
          puts "🏢 Conversation: #{post.conversation_name}"
          
          if post.tile
            expect(post.tile).to respond_to(:tile_name)
            expect(post.tile).to respond_to(:tile_content)
            expect(post.tile).to respond_to(:tile_full_description)
            expect(post.tile).to respond_to(:tile_image)
            puts "✅ Tile structure validated"
            puts "📝 Tile: #{post.tile.tile_name}"
            puts "📄 Full description available: #{post.tile.tile_full_description.length > 0 ? 'Yes' : 'No'}"
          end
          
          # Test post permissions and settings
          expect(post).to respond_to(:can_edit)
          expect(post).to respond_to(:can_comment)
          expect(post).to respond_to(:can_delete)
          expect(post).to respond_to(:can_archive)
          expect(post).to respond_to(:is_draft)
          expect(post).to respond_to(:archived)
          puts "✅ Post permissions validated"
          puts "📝 Can edit: #{post.can_edit} | Can comment: #{post.can_comment} | Can delete: #{post.can_delete}"
          puts "📝 Is draft: #{post.is_draft} | Archived: #{post.archived}"
        else
          puts "📊 Post details not found"
        end
      end
    end
  end
end
