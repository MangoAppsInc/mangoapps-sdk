# MangoApps Ruby SDK

A clean, **real TDD** Ruby SDK for MangoApps APIs with OAuth2/OpenID Connect authentication. Features intuitive dot notation access, automatic response wrapping, and comprehensive real-world testing with actual MangoApps credentials.

## Features

- 🔐 **OAuth2/OpenID Connect** authentication with automatic token refresh
- 🚀 **Simple API** with intuitive method names and clean dot notation
- 🧪 **Real TDD** - no mocking, only actual OAuth testing
- 🔄 **Automatic retries** with exponential backoff
- 📝 **Comprehensive error handling** with specific exception types
- 🛡️ **Security-first** design with PKCE support
- 🔧 **Environment variable configuration** for secure credentials
- 📚 **Well-documented** with examples and guides
- ✨ **Clean Response API** - Automatic response wrapping with intuitive dot notation access
- 🔔 **Notifications Module** - User priority items including requests, events, quizzes, surveys, tasks, and todos
- 📰 **Feeds Module** - User activity feeds with unread counts and feed details
- 📝 **Posts Module** - Get all posts with filtering options and post management

## Installation

Add this line to your application's Gemfile:

```ruby
gem "mangoapps-sdk"
```

And then execute:

```bash
bundle install
```

Or install it directly:

```bash
gem install mangoapps-sdk
```

## Quick Start

### 1. Environment Setup

For testing purposes, create a `.env` file with your MangoApps credentials:

```bash
# .env (for testing only)
MANGOAPPS_DOMAIN=yourdomain.mangoapps.com
MANGOAPPS_CLIENT_ID=your_client_id_here
MANGOAPPS_CLIENT_SECRET=your_client_secret_here
MANGOAPPS_REDIRECT_URI=https://localhost:3000/oauth/callback
MANGOAPPS_SCOPE=openid profile email
```

**Note**: The `.env` file is only used for testing. In production, you should handle token storage and management according to your application's security requirements.

### 2. Configuration

```ruby
require "mangoapps"

# For testing - automatically loads from .env file
config = MangoApps::Config.new

# For production - provide credentials directly
config = MangoApps::Config.new(
  domain: "yourdomain.mangoapps.com",
  client_id: "your_client_id",
  client_secret: "your_client_secret",
  redirect_uri: "https://localhost:3000/oauth/callback",
  scope: "openid profile email"
)

client = MangoApps::Client.new(config)
```

### 3. OAuth Authentication

#### Quick Start (Recommended)
```bash
# Get OAuth token (interactive)
./run_auth.sh

# Run tests to verify everything works
./run_tests.sh
```

#### Basic Usage Example
```ruby
require 'mangoapps-sdk'

# Initialize client
client = MangoApps::Client.new

# Get user profile
user = client.me
puts "Hello, #{user.name}!"

# Get priority items
priority_items = client.my_priority_items
puts "You have #{priority_items.data.length} priority items:"
priority_items.data.each do |item|
  puts "  • #{item.title}: #{item.count} pending"
end

# Get available courses
courses = client.course_catalog
puts "Available courses: #{courses.courses.length}"

# Get activity feeds
feeds = client.feeds
puts "Activity feeds: #{feeds.feeds.length} (unread: #{feeds.unread_counts.unread_feeds_count})"

# Get all posts
posts = client.get_all_posts(filter_by: "all")
puts "All posts: #{posts.feeds.length}"

# Get post details by ID
if posts.feeds.any?
  post_id = posts.feeds.first.post_id
  post_details = client.get_post_by_id(post_id, full_description: "Y")
  puts "Post details: #{post_details.post.title}"
end

# Get user libraries
libraries = client.get_libraries
puts "User libraries: #{libraries.libraries.length}"

# Get library categories by ID
if libraries.libraries.any?
  library_id = libraries.libraries.first.id
  library_details = client.get_library_categories(library_id)
  puts "Library details: #{library_details.library.name}"
  
  # Get library items from first category
  if library_details.library.categories.any?
    category_id = library_details.library.categories.first.id
    library_items = client.get_library_items(library_id, category_id)
    puts "Library items: #{library_items.library_items.length} items in #{library_items.category_name}"
  end
end

# Get user trackers
trackers = client.get_trackers
puts "User trackers: #{trackers.trackers.length}"

# Get user folders
folders = client.get_folders
puts "User folders: #{folders.folders.length}"

# Get files from first folder with content
if folders.folders.any?
  folder_with_content = folders.folders.find { |f| f.child_count.to_i > 0 }
  if folder_with_content
    folder_files = client.get_folder_files(folder_with_content.id, include_folders: "Y")
    puts "Folder files: #{folder_files.files.length} items in #{folder_files.name}"
  end
end
```

#### Manual OAuth Flow
```ruby
# Generate authorization URL
state = SecureRandom.hex(16)
auth_url = client.authorization_url(state: state)
puts "Open this URL to authorize: #{auth_url}"

# After user authorizes, exchange code for tokens
tokens = client.authenticate!(authorization_code: params[:code])

# Store tokens securely in your application
# (implementation depends on your storage solution)
store_tokens(tokens.access_token, tokens.refresh_token)

# Now you can make API calls with clean dot notation
user = client.me
puts "Welcome, #{user.user_profile.minimal_profile.name}!"
```

## Response Format

The SDK automatically wraps all API responses in a `MangoApps::Response` object that provides clean dot notation access:

```ruby
# Clean dot notation access (automatic response wrapping):
user = client.me
name = user.user_profile.minimal_profile.name
email = user.user_profile.minimal_profile.email
```

### Response Features

- **🎯 Dot Notation Access**: `response.user.name` for clean, intuitive API access
- **🔄 Automatic Wrapping**: All responses are automatically wrapped in `MangoApps::Response`
- **🔗 Hash Compatibility**: Still supports `[]` access if needed
- **📊 Enumerable Support**: Arrays and hashes work as expected
- **🔍 Raw Data Access**: Use `response.raw_data` for original response
- **⚡ Type Safety**: Better IDE support and autocomplete
- **🎨 Clean Code**: No more verbose nested hash access

## API Resources

### Users Module

```ruby
# Get current user profile
user = client.me

# Access user data with clean dot notation
puts "User: #{user.user_profile.minimal_profile.name}"
puts "Email: #{user.user_profile.minimal_profile.email}"
puts "Points: #{user.user_profile.gamification.total_points}"
puts "Followers: #{user.user_profile.user_data.followers}"
```

### Learn Module

#### Course Catalog
```ruby
# Get course catalog
courses = client.course_catalog

# Access course data with clean dot notation
courses.courses.each do |course|
  puts "#{course.name} - #{course.course_type}"
end
```

#### Course Categories
```ruby
# Get all course categories
categories = client.course_categories

# Access category data with clean dot notation
categories.all_categories.each do |category|
  puts "#{category.name} - Position: #{category.position}"
end

# Get specific category details
category = client.course_category(category_id)
```

#### Course Details
```ruby
# Get detailed course information by course ID
course_id = 604
course = client.course_details(course_id)

# Access course data with clean dot notation
course_data = course.course
puts "Course: #{course_data.name} (ID: #{course_data.id})"
puts "Description: #{course_data.description}"
puts "Type: #{course_data.course_type}"
puts "Delivery Mode: #{course_data.delivery_mode}"
puts "Instructors: #{course_data.instructors.length}"
puts "Fields: #{course_data.fields.length}"

# Access course URLs
puts "Start Course URL: #{course_data.start_course_url}"
puts "Go to Course URL: #{course_data.goto_course_url}"

# Access course fields (details, certification, etc.)
course_data.fields.each do |field|
  puts "Field: #{field.field_name}"
  field.course_sub_fields.each do |sub_field|
    puts "  #{sub_field.field_name}: #{sub_field.field_value}"
  end
end
```

#### My Learning
```ruby
# Get user's learning progress and courses
learning = client.my_learning

# Access user learning data with clean dot notation
puts "User: #{learning.user_name} (ID: #{learning.user_id})"
puts "Total training time: #{learning.total_training_time}"
puts "Ongoing courses: #{learning.ongoing_course_count}"
puts "Completed courses: #{learning.completed_course_count}"
puts "Registered courses: #{learning.registered_course_count}"

# Access learning sections
learning.section.each do |section|
  puts "#{section.label} - #{section.count} courses"
  
  # Access courses in each section
  section.courses.each do |course|
    puts "  📚 #{course.name} - #{course.course_progress}% progress"
  end
end
```

### Recognitions Module

#### Award Categories
```ruby
# Get award categories
categories = client.award_categories

# Access award category data with clean dot notation
categories.award_categories.each do |category|
  puts "#{category.name} (ID: #{category.id}) - Permission: #{category.recipient_permission}"
end
```

#### Core Value Tags
```ruby
# Get core value tags
tags = client.core_value_tags

# Access core value tag data with clean dot notation
tags.core_value_tags.each do |tag|
  puts "#{tag.name} (ID: #{tag.id}) - Color: ##{tag.color}"
end
```

#### Leaderboard Info
```ruby
# Get leaderboard information
leaderboard = client.leaderboard_info

# Check if leaderboard data is available
if leaderboard.leaderboard_info
  # Access user leaderboard with clean dot notation
  leaderboard.leaderboard_info.user_info.each do |user|
    puts "🏅 #{user.name} (Rank: #{user.rank}) - Awards: #{user.award_count}"
  end
  
  # Access team leaderboard with clean dot notation
  leaderboard.leaderboard_info.team_info.each do |team|
    puts "🏆 #{team.name} (Rank: #{team.rank}) - Awards: #{team.award_count}"
  end
else
  puts "No leaderboard data configured"
end
```

#### Tango Gift Cards
```ruby
# Get tango gift cards information
gift_cards = client.tango_gift_cards

# Access gift card data with clean dot notation
puts "Available points: #{gift_cards.tango_cards.available_points}"
puts "Terms: #{gift_cards.tango_cards.terms}"
```

#### Gift Cards
```ruby
# Get gift cards information
gift_cards = client.gift_cards

# Access gift card data with clean dot notation
gift_cards.cards.each do |card|
  puts "#{card.brand_name} (Key: #{card.brand_key}) - Enabled: #{card.enabled}"
end
```

#### Get Awards List
```ruby
# Get awards list for a specific category
response = client.get_awards_list(category_id: 4303)

# Access award data with clean dot notation
response.get_awards_list.each do |award|
  puts "#{award.name} (ID: #{award.id})"
  puts "  Description: #{award.description}"
  puts "  Points: #{award.points}"
  puts "  Reward Points: #{award.reward_points}"
  puts "  Image: #{award.attachment_url}"
end
```

#### Get Profile Awards
```ruby
# Get user profile awards
response = client.get_profile_awards

# Access core value tags with counts
response.core_value_tags.each do |tag|
  puts "#{tag.name} (ID: #{tag.id}) - Count: #{tag.count}"
end

# Access award feeds
response.feeds.each do |feed|
  puts "#{feed.feed_property.title} - Points: #{feed.recognition_points}"
  puts "From: #{feed.from_user.name}"
  puts "Body: #{feed.body}"
end
```

#### Get Team Awards
```ruby
# Get team awards for a specific project/team
response = client.get_team_awards(project_id: 117747)

# Access team core value tags with counts
response.core_value_tags.each do |tag|
  puts "#{tag.name} (ID: #{tag.id}) - Count: #{tag.count}"
end

# Access team award feeds
response.feeds.each do |feed|
  puts "#{feed.feed_property.title} - Points: #{feed.recognition_points}"
  puts "From: #{feed.from_user.name}"
  puts "Team: #{feed.group_name} (ID: #{feed.group_id})"
  puts "Body: #{feed.body}"
end
```

#### My Priority Items
```ruby
# Get user's priority items
response = client.my_priority_items

# Access priority items data
response.data.each do |item|
  puts "#{item.title} (ID: #{item.id}) - Count: #{item.count}"
  puts "  Action Type: #{item.action_type}"
  puts "  Icon: #{item.icon} (#{item.icon_color})"
  puts "  Details: #{item.info_details}"
end

# Check response status
puts "Success: #{response.success}"
puts "Display Type: #{response.display_type}"
```

#### Feeds
```ruby
# Get user's activity feeds
response = client.feeds

# Access feeds data
response.feeds.each do |feed|
  puts "#{feed.feed_property.title} (ID: #{feed.id})"
  puts "  From: #{feed.from_user.name} | Group: #{feed.group_name}"
  puts "  Type: #{feed.feed_type} | Category: #{feed.category}"
  puts "  Created: #{Time.at(feed.created_at.to_i).strftime('%Y-%m-%d %H:%M:%S')}"
  puts "  Unread: #{feed.unread}"
  puts "  Body: #{feed.body[0..100]}..."
end

# Access unread counts
puts "Unread feeds: #{response.unread_counts.unread_feeds_count}"
puts "Direct messages: #{response.unread_counts.direct_messages_count}"
puts "What's new: #{response.unread_counts.whats_new_count}"

# Check response metadata
puts "Limit: #{response.limit} | Version: #{response.mangoapps_version}"
```

#### Get All Posts
```ruby
# Get all posts with filtering
response = client.get_all_posts(filter_by: "all")

# Access posts data
response.feeds.each do |post|
  puts "#{post.tile.tile_name} (ID: #{post.id})"
  puts "  From: #{post.from_user.name} | Group: #{post.group_name}"
  puts "  Post ID: #{post.post_id} | View count: #{post.total_view_count}"
  puts "  Created: #{Time.at(post.created_at.to_i).strftime('%Y-%m-%d %H:%M:%S')}"
  puts "  Comments: #{post.comments.length} | Likes: #{post.like_count}"
  puts "  Content: #{post.tile.tile_content[0..100]}..."
end

# Access post configuration
puts "Post view count visibility: #{response.post_view_count_visibility}"
puts "Post view count link config: #{response.post_view_count_link_config}"
```

#### Get Post By ID
```ruby
# Get detailed post information by ID
post_id = 59101
response = client.get_post_by_id(post_id, full_description: "Y")

# Access post details
post = response.post
puts "#{post.title} (ID: #{post.id})"
puts "  Created by: #{post.created_name} (ID: #{post.creator_by})"
puts "  Created: #{Time.at(post.created_at.to_i).strftime('%Y-%m-%d %H:%M:%S')}"
puts "  Conversation: #{post.conversation_name}"
puts "  View count: #{post.total_view_count} | Likes: #{post.like_count} | Comments: #{post.comment_count}"

# Access tile information
if post.tile
  puts "  Tile: #{post.tile.tile_name}"
  puts "  Full description: #{post.tile.tile_full_description[0..200]}..."
  puts "  Image: #{post.tile.tile_image}"
end

# Check post permissions
puts "  Can edit: #{post.can_edit} | Can comment: #{post.can_comment} | Can delete: #{post.can_delete}"
puts "  Is draft: #{post.is_draft} | Archived: #{post.archived}"
```

#### Libraries Management
```ruby
# Get user's document libraries
libraries = client.get_libraries

# Access libraries data
puts "📚 User Libraries:"
libraries.libraries.each do |library|
  puts "  • #{library.name} (ID: #{library.id})"
  puts "    Type: #{library.library_type} | View: #{library.view_mode}"
  puts "    Items: #{library.total_items_count} | Categories: #{library.categories.length}"
  puts "    Edit access: #{library.edit_access} | Position: #{library.position}"
  puts "    Banner: #{library.banner_color} | Icon: #{library.icon_properties.color}"
  
  # Access library categories
  if library.categories.any?
    puts "    Categories:"
    library.categories.first(3).each do |category|
      puts "      - #{category.name} (#{category.library_items_count} items)"
    end
  end
  puts ""
end
```

#### Get Library Categories
```ruby
# Get detailed library information and categories by library ID
library_id = 9776
response = client.get_library_categories(library_id)

# Access library details
library = response.library
puts "#{library.name} (ID: #{library.id})"
puts "  Type: #{library.library_type} | View: #{library.view_mode}"
puts "  Description: #{library.description}"
puts "  Total items: #{library.total_items_count} | Categories: #{library.categories.length}"
puts "  Edit access: #{library.edit_access} | Position: #{library.position}"

# Access library properties
puts "  Banner color: #{library.banner_color} | Icon color enabled: #{library.enable_icon_color}"
puts "  Created: #{Time.at(library.created_at.to_i).strftime('%Y-%m-%d %H:%M:%S')}"
puts "  Updated: #{Time.at(library.updated_at.to_i).strftime('%Y-%m-%d %H:%M:%S')}"

# Access icon properties
if library.icon_properties
  puts "  Icon color: #{library.icon_properties.color} | Icon class: #{library.icon_properties.class}"
end

# Access categories
if library.categories.any?
  puts "  Categories:"
  library.categories.each do |category|
    puts "    • #{category.name} (ID: #{category.id})"
    puts "      Items: #{category.library_items_count} | Rank: #{category.rank}"
    puts "      Is system: #{category.is_system} | Icon: #{category.icon || 'None'}"
    if category.description
      puts "      Description: #{category.description[0..100]}..."
    end
  end
end
```

#### Get Library Items
```ruby
# Get library items by library ID and category ID
library_id = 9776
category_id = 50114
response = client.get_library_items(library_id, category_id)

# Access library items data
puts "Category: #{response.category_name}"
puts "View mode: #{response.view_mode} | Library type: #{response.library_type}"
puts "Library ID: #{response.library_id} | Can add: #{response.can_add}"
puts "Icon color: #{response.enable_icon_color}"

# Access library items
if response.library_items.any?
  puts "Library Items:"
  response.library_items.each do |item|
    puts "  • #{item.name} (ID: #{item.id})"
    puts "    Link type: #{item.link_type} | Link: #{item.link[0..50]}..."
    
    # Handle different link types
    if item.link_type == "ExternalLink"
      if item.icon_properties
        puts "    Icon: #{item.icon_properties.color} | Class: #{item.icon_properties.class}"
      end
    elsif item.link_type == "Attachment"
      puts "    Attachment ID: #{item.attachment_id} | File type: #{item.file_type}"
      puts "    Likes: #{item.likes_count} | Is liked: #{item.is_liked}"
      puts "    Image: #{item.image_url}"
      puts "    Short URL: #{item.short_url[0..50]}..."
    end
  end
else
  puts "No library items found"
end
```

#### Trackers Management
```ruby
# Get user's trackers
trackers = client.get_trackers

# Access trackers data
puts "📊 User Trackers:"
puts "  Total trackers: #{trackers.trackers.length}"
puts "  Transaction ID: #{trackers.transaction_id || 'None'}"
puts ""

# Display recent trackers
puts "📊 Recent Trackers:"
trackers.trackers.first(5).each do |tracker|
  puts "  • #{tracker.name} (ID: #{tracker.id})"
  puts "    Last submission: #{Time.at(tracker.last_submission_date.to_i).strftime('%Y-%m-%d %H:%M:%S')}"
  puts "    Conversation: #{tracker.conversation_name} (ID: #{tracker.conversation_id})"
  puts "    Pinned: #{tracker.is_pinned} | Can share: #{tracker.can_share}"
  
  # Access tracker icon info
  if tracker.tracker_icon_info
    puts "    Icon: #{tracker.tracker_icon_info.color_code} | Class: #{tracker.tracker_icon_info.icon_url}"
  end
  
  puts "    MLink: #{tracker.mlink[0..50]}..."
  puts ""
end
```

#### Attachments Management
```ruby
# Get user's folders
folders = client.get_folders

# Access folders data
puts "📁 User Folders:"
puts "  Total folders: #{folders.folders.length}"
puts "  Transaction ID: #{folders.transaction_id || 'None'}"
puts ""

# Display folders
puts "📁 Available Folders:"
folders.folders.each do |folder|
  puts "  • #{folder.name} (ID: #{folder.id})"
  puts "    Path: #{folder.relativePath}"
  puts "    Child count: #{folder.child_count} | Can save: #{folder.can_save}"
  puts "    Pinned: #{folder.is_pinned} | Virtual: #{folder.is_virtual_folder}"
  puts "    Folder rel: #{folder.folder_rel} | Type: #{folder.folder_type_from_db || 'None'}"
  puts "    Show in upload: #{folder.show_in_upload} | Show in move: #{folder.show_in_move}"
  puts "    Filter: #{folder.filter} | Show permissions: #{folder.show_permission_options}"
  
  # Show conversation and user IDs if available
  if folder.conversation_id
    puts "    Conversation ID: #{folder.conversation_id}"
  end
  if folder.user_id
    puts "    User ID: #{folder.user_id}"
  end
  
  puts ""
end
```

#### File and Folder Management
```ruby
# Get user's folders first
folders = client.get_folders

# Find a folder with content
if folders.folders.any?
  folder = folders.folders.find { |f| f.child_count.to_i > 0 }
  
  if folder
    puts "📁 Exploring folder: #{folder.name} (ID: #{folder.id})"
    
    # Get files and folders inside this folder
    folder_contents = client.get_folder_files(folder.id, include_folders: "Y")
    
    puts "📁 Folder Contents:"
    puts "  Folder name: #{folder_contents.name}"
    puts "  Total count: #{folder_contents.total_count}"
    puts "  Role: #{folder_contents.role_name}"
    puts "  Domain suspended: #{folder_contents.is_domain_suspended}"
    puts "  Show in upload: #{folder_contents.show_in_upload}"
    puts ""
    
    # Display files and folders
    puts "📁 Files and Folders:"
    folder_contents.files.first(10).each do |item|
      puts "  • #{item.filename} (ID: #{item.id})"
      puts "    Type: #{item.is_folder ? 'Folder' : 'File'}"
      puts "    Size: #{item.size} bytes"
      puts "    Uploader: #{item.uploader_name} (ID: #{item.user_id})"
      puts "    Updated: #{Time.at(item.updated_at.to_i).strftime('%Y-%m-%d %H:%M:%S')}"
      puts "    Visibility: #{item.visibility} | Privacy: #{item.privacy_type}"
      puts "    Pinned: #{item.is_pinned} | Liked: #{item.is_liked}"
      puts "    Can save: #{item.can_save} | Show permissions: #{item.show_permission_options}"
      
      # Show role permissions
      if item.role
        puts "    Permissions: Edit: #{item.role.can_edit} | Share: #{item.role.can_share} | Restore: #{item.role.can_restore}"
      end
      
      # Show links
      if item.mLink
        puts "    MLink: #{item.mLink[0..50]}..."
      end
      
      puts ""
    end
  else
    puts "No folders with content found"
  end
else
  puts "No folders found"
end
```

## Available Modules

### ✅ Currently Implemented

#### Users Module
- **User Profile**: `client.me` - Get current user information with clean dot notation access

#### Learn Module  
- **Course Catalog**: `client.course_catalog` - Get available courses
- **Course Categories**: `client.course_categories` - Get course categories
- **Course Details**: `client.course_details(course_id)` - Get detailed course information by ID
- **My Learning**: `client.my_learning` - Get user's learning progress and courses

#### Recognitions Module
- **Award Categories**: `client.award_categories` - Get recognition award categories
- **Get Awards List**: `client.get_awards_list(category_id: id)` - Get awards for a specific category
- **Get Profile Awards**: `client.get_profile_awards` - Get user's personal awards and activity
- **Get Team Awards**: `client.get_team_awards(project_id: id)` - Get team awards and activity
- **Core Value Tags**: `client.core_value_tags` - Get core value tags for recognition
- **Leaderboard Info**: `client.leaderboard_info` - Get user and team leaderboard information
- **Tango Gift Cards**: `client.tango_gift_cards` - Get tango gift cards information and available points
- **Gift Cards**: `client.gift_cards` - Get available gift cards for recognition rewards

#### Notifications Module
- **My Priority Items**: `client.my_priority_items` - Get user's priority items including requests, events, quizzes, surveys, tasks, and todos

#### Feeds Module
- **Feeds**: `client.feeds` - Get user's activity feeds with unread counts and feed details

#### Posts Module
- **Get All Posts**: `client.get_all_posts(filter_by: "all")` - Get all posts with filtering options
- **Get Post By ID**: `client.get_post_by_id(post_id, full_description: "Y")` - Get detailed post information by ID

#### Libraries Module
- **Get Libraries**: `client.get_libraries` - Get user's document libraries with categories and items
- **Get Library Categories**: `client.get_library_categories(library_id)` - Get detailed library information and categories by library ID
- **Get Library Items**: `client.get_library_items(library_id, category_id)` - Get library items by library ID and category ID

#### Trackers Module
- **Get Trackers**: `client.get_trackers` - Get user's trackers with submission dates and conversation details

#### Attachments Module
- **Get Folders**: `client.get_folders` - Get user's file folders with permissions and metadata
- **Get Folder Files**: `client.get_folder_files(folder_id, include_folders: "Y")` - Get files and folders inside a specific folder

## Complete Examples

### Notifications Management
```ruby
require 'mangoapps-sdk'

# Initialize client
client = MangoApps::Client.new

# Get user's priority items
priority_items = client.my_priority_items

# Display all priority items with details
puts "🔔 User Priority Items Dashboard"
puts "================================"
puts "Success: #{priority_items.success}"
puts "Display Type: #{priority_items.display_type}"
puts ""

priority_items.data.each do |item|
  puts "📋 #{item.title} (ID: #{item.id})"
  puts "   Count: #{item.count} pending items"
  puts "   Action Type: #{item.action_type}"
  puts "   Icon: #{item.icon} (#{item.icon_color})"
  puts "   Background: #{item.icon_bg_color}"
  puts "   Description: #{item.info_details.gsub(/<[^>]*>/, '').strip[0..100]}..."
  puts ""
end

# Filter by specific action types
approval_items = priority_items.data.select { |item| item.action_type == 'approval' }
puts "🔍 Approval Items: #{approval_items.length}"
approval_items.each do |item|
  puts "  • #{item.title}: #{item.count} items"
end

# Get high-priority items (count > 5)
high_priority = priority_items.data.select { |item| item.count > 5 }
puts "⚠️  High Priority Items: #{high_priority.length}"
high_priority.each do |item|
  puts "  • #{item.title}: #{item.count} items"
end
```

### User Profile Management
```ruby
# Get current user profile
user = client.me

# Access user information with clean dot notation
puts "Name: #{user.user_profile.minimal_profile.name}"
puts "Email: #{user.user_profile.minimal_profile.email}"
puts "User Type: #{user.user_profile.minimal_profile.user_type}"

# Access user statistics
puts "Followers: #{user.user_profile.user_data.followers}"
puts "Following: #{user.user_profile.user_data.following}"

# Access gamification data
puts "Current Level: #{user.user_profile.gamification.current_level}"
puts "Total Points: #{user.user_profile.gamification.total_points}"
puts "Badges: #{user.user_profile.gamification.badges.length}"

# Access recognition data
puts "Reward Points Received: #{user.user_profile.recognition.total_reward_points_received}"
```

### Learning Management
```ruby
# Get course catalog
courses = client.course_catalog

# Browse available courses
courses.courses.each do |course|
  puts "📚 #{course.name}"
  puts "   Type: #{course.course_type}"
  puts "   Delivery: #{course.delivery_mode}"
  puts "   URL: #{course.start_course_url}"
  puts ""
  
  # Get detailed course information
  course_details = client.course_details(course.id)
  detailed_course = course_details.course
  puts "   📖 Detailed Info:"
  puts "   Description: #{detailed_course.description}"
  puts "   Instructors: #{detailed_course.instructors.length}"
  puts "   Fields: #{detailed_course.fields.length}"
  puts ""
end

# Get course categories
categories = client.course_categories

# Browse course categories
categories.all_categories.each do |category|
  puts "📂 #{category.name}"
  puts "   Position: #{category.position}"
  puts "   Icon: #{category.icon_properties}"
  puts ""
end

# Get user's learning progress
learning = client.my_learning

# Display learning summary
puts "🎓 Learning Summary for #{learning.user_name}"
puts "⏱️ Total training time: #{learning.total_training_time}"
puts "📚 Ongoing: #{learning.ongoing_course_count} | ✅ Completed: #{learning.completed_course_count} | 📝 Registered: #{learning.registered_course_count}"
puts ""

# Browse learning sections
learning.section.each do |section|
  puts "📂 #{section.label} (#{section.count} courses)"
  
  section.courses.each do |course|
    puts "  📚 #{course.name}"
    puts "     Progress: #{course.course_progress}%"
    puts "     Type: #{course.course_type}"
    puts "     URL: #{course.start_course_url}"
    puts ""
  end
end
```

### Recognition Management
```ruby
# Get award categories
categories = client.award_categories

# Display available award categories
puts "🏆 Available Award Categories:"
categories.award_categories.each do |category|
  puts "  • #{category.name} (ID: #{category.id})"
  puts "    Permission: #{category.recipient_permission}"
end
puts ""

# Get awards for a specific category
category_id = 4303  # Safety & Quality category
awards = client.get_awards_list(category_id: category_id)

# Display awards in the category
puts "🏆 Awards in Category #{category_id}:"
awards.get_awards_list.each do |award|
  puts "  • #{award.name} (ID: #{award.id})"
  puts "    Points: #{award.points} | Reward Points: #{award.reward_points || 'None'}"
  puts "    Description: #{award.description}"
end
puts ""

# Get user profile awards
profile_awards = client.get_profile_awards

# Display user's personal awards
puts "🏆 User Profile Awards:"
puts "  Core Value Tags:"
profile_awards.core_value_tags.each do |tag|
  puts "    • #{tag.name} (ID: #{tag.id}) - Count: #{tag.count}"
end
puts "  Recent Awards:"
profile_awards.feeds.each do |feed|
  puts "    • #{feed.feed_property.title} - Points: #{feed.recognition_points}"
  puts "      From: #{feed.from_user.name}"
end
puts ""

# Get team awards
team_id = 117747  # All Users team
team_awards = client.get_team_awards(project_id: team_id)

# Display team awards
puts "🏆 Team Awards (Team ID: #{team_id}):"
puts "  Team Core Value Tags:"
team_awards.core_value_tags.each do |tag|
  puts "    • #{tag.name} (ID: #{tag.id}) - Count: #{tag.count}"
end
puts "  Team Recent Awards:"
team_awards.feeds.each do |feed|
  puts "    • #{feed.feed_property.title} - Points: #{feed.recognition_points}"
  puts "      From: #{feed.from_user.name} | Team: #{feed.group_name}"
end
puts ""

# Get user priority items
priority_items = client.my_priority_items

# Display priority items
puts "🔔 User Priority Items:"
priority_items.data.each do |item|
  puts "  • #{item.title} (ID: #{item.id}) - Count: #{item.count}"
  puts "    Action Type: #{item.action_type} | Icon: #{item.icon}"
end
puts ""

# Get user activity feeds
feeds = client.feeds

# Display feeds
puts "📰 User Activity Feeds:"
puts "  Total feeds: #{feeds.feeds.length}"
puts "  Unread feeds: #{feeds.unread_counts.unread_feeds_count}"
puts "  Direct messages: #{feeds.unread_counts.direct_messages_count}"
puts "  What's new: #{feeds.unread_counts.whats_new_count}"
puts ""

# Display recent feeds
puts "📰 Recent Feeds:"
feeds.feeds.first(3).each do |feed|
  puts "  • #{feed.feed_property.title} (ID: #{feed.id})"
  puts "    From: #{feed.from_user.name} | Group: #{feed.group_name}"
  puts "    Type: #{feed.feed_type} | Unread: #{feed.unread}"
end
puts ""

# Get all posts
posts = client.get_all_posts(filter_by: "all")

# Display posts
puts "📝 All Posts:"
puts "  Total posts: #{posts.feeds.length}"
puts "  Post view count visibility: #{posts.post_view_count_visibility}"
puts ""

# Display recent posts
puts "📝 Recent Posts:"
posts.feeds.first(3).each do |post|
  puts "  • #{post.tile.tile_name} (ID: #{post.id})"
  puts "    From: #{post.from_user.name} | Group: #{post.group_name}"
  puts "    Views: #{post.total_view_count} | Comments: #{post.comments.length}"
end
puts ""

# Get detailed post information
if posts.feeds.any?
  first_post_id = posts.feeds.first.post_id
  post_details = client.get_post_by_id(first_post_id, full_description: "Y")
  
  puts "📝 Post Details (ID: #{first_post_id}):"
  puts "  Title: #{post_details.post.title}"
  puts "  Created by: #{post_details.post.created_name}"
  puts "  View count: #{post_details.post.total_view_count}"
  puts "  Can edit: #{post_details.post.can_edit} | Can comment: #{post_details.post.can_comment}"
  puts "  Full description available: #{post_details.post.tile.tile_full_description.length > 0 ? 'Yes' : 'No'}"
end
puts ""

# Get user libraries
libraries = client.get_libraries

puts "📚 User Libraries:"
puts "  Total libraries: #{libraries.libraries.length}"
puts ""

# Display recent libraries
puts "📚 Recent Libraries:"
libraries.libraries.first(3).each do |library|
  puts "  • #{library.name} (ID: #{library.id})"
  puts "    Type: #{library.library_type} | Items: #{library.total_items_count}"
  puts "    Categories: #{library.categories.length} | Edit access: #{library.edit_access}"
end
puts ""

# Get detailed library information
if libraries.libraries.any?
  first_library_id = libraries.libraries.first.id
  library_details = client.get_library_categories(first_library_id)
  
  puts "📚 Library Details (ID: #{first_library_id}):"
  puts "  Name: #{library_details.library.name}"
  puts "  Type: #{library_details.library.library_type} | View: #{library_details.library.view_mode}"
  puts "  Total items: #{library_details.library.total_items_count}"
  puts "  Categories: #{library_details.library.categories.length}"
  puts "  Edit access: #{library_details.library.edit_access}"
  
  # Get library items from first category
  if library_details.library.categories.any?
    first_category_id = library_details.library.categories.first.id
    library_items = client.get_library_items(first_library_id, first_category_id)
    
    puts "📚 Library Items (Category: #{library_items.category_name}):"
    puts "  View mode: #{library_items.view_mode} | Library type: #{library_items.library_type}"
    puts "  Items count: #{library_items.library_items.length}"
    puts "  Can add: #{library_items.can_add}"
  end
end
puts ""

# Get user trackers
trackers = client.get_trackers

puts "📊 User Trackers:"
puts "  Total trackers: #{trackers.trackers.length}"
puts ""

# Display recent trackers
puts "📊 Recent Trackers:"
trackers.trackers.first(3).each do |tracker|
  puts "  • #{tracker.name} (ID: #{tracker.id})"
  puts "    Last submission: #{Time.at(tracker.last_submission_date.to_i).strftime('%Y-%m-%d %H:%M:%S')}"
  puts "    Conversation: #{tracker.conversation_name}"
  puts "    Pinned: #{tracker.is_pinned} | Can share: #{tracker.can_share}"
end
puts ""

# Get user folders
folders = client.get_folders

puts "📁 User Folders:"
puts "  Total folders: #{folders.folders.length}"
puts ""

# Display first few folders
puts "📁 Available Folders:"
folders.folders.first(3).each do |folder|
  puts "  • #{folder.name} (ID: #{folder.id})"
  puts "    Path: #{folder.relativePath} | Child count: #{folder.child_count}"
  puts "    Can save: #{folder.can_save} | Pinned: #{folder.is_pinned}"
end
puts ""

# Get files from first folder with content
if folders.folders.any?
  folder_with_content = folders.folders.find { |f| f.child_count.to_i > 0 }
  if folder_with_content
    folder_files = client.get_folder_files(folder_with_content.id, include_folders: "Y")
    puts "📁 Folder Files:"
    puts "  Folder: #{folder_files.name} | Total: #{folder_files.total_count}"
    puts "  Role: #{folder_files.role_name} | Upload enabled: #{folder_files.show_in_upload}"
  end
end
puts ""

# Get core value tags
tags = client.core_value_tags

# Display core value tags
puts "🎯 Core Value Tags:"
tags.core_value_tags.each do |tag|
  puts "  • #{tag.name} (ID: #{tag.id})"
  puts "    Color: ##{tag.color}"
end
puts ""

# Get leaderboard information
leaderboard = client.leaderboard_info

# Display leaderboard if available
if leaderboard.leaderboard_info
  puts "🏅 User Leaderboard:"
  leaderboard.leaderboard_info.user_info.each do |user|
    puts "  #{user.rank}. #{user.name} - #{user.award_count} awards"
  end
  puts ""
  
  puts "🏆 Team Leaderboard:"
  leaderboard.leaderboard_info.team_info.each do |team|
    puts "  #{team.rank}. #{team.name} - #{team.award_count} awards"
  end
else
  puts "📊 No leaderboard data configured"
end

# Get tango gift cards information
tango_gift_cards = client.tango_gift_cards

# Display tango gift card information
puts "🎁 Tango Gift Cards:"
puts "  Available points: #{tango_gift_cards.tango_cards.available_points}"
puts "  Terms: #{tango_gift_cards.tango_cards.terms[0..100]}..." if tango_gift_cards.tango_cards.terms
puts ""

# Get gift cards information
gift_cards = client.gift_cards

# Display available gift cards
puts "🎁 Available Gift Cards:"
gift_cards.cards.each do |card|
  puts "  • #{card.brand_name} (Key: #{card.brand_key}) - Enabled: #{card.enabled}"
end
```

### Error Handling with Clean Responses
```ruby
begin
  user = client.me
  
  # Clean dot notation access
  puts "Welcome, #{user.user_profile.minimal_profile.name}!"
  
rescue MangoApps::AuthenticationError => e
  puts "Authentication failed: #{e.message}"
  # Redirect to OAuth flow
  
rescue MangoApps::APIError => e
  puts "API error: #{e.message}"
  puts "Status: #{e.status_code}"
  
rescue MangoApps::RateLimitError => e
  puts "Rate limited: #{e.message}"
  # Implement backoff strategy
end
```


## Error Handling

The SDK provides specific exception types for different error scenarios:

```ruby
begin
  posts = client.posts_list
rescue MangoApps::AuthenticationError => e
  puts "Authentication failed: #{e.message}"
rescue MangoApps::APIError => e
  puts "API error: #{e.message}"
rescue MangoApps::RateLimitError => e
  puts "Rate limited: #{e.message}"
end
```

### Available Exception Types

- `MangoApps::Error` - Base error class
- `MangoApps::APIError` - General API errors
- `MangoApps::AuthenticationError` - Authentication failures
- `MangoApps::TokenExpiredError` - Token expiration
- `MangoApps::BadRequestError` - 400 errors
- `MangoApps::UnauthorizedError` - 401 errors
- `MangoApps::ForbiddenError` - 403 errors
- `MangoApps::NotFoundError` - 404 errors
- `MangoApps::RateLimitError` - 429 errors
- `MangoApps::ServerError` - 5xx errors

## Configuration Options

```ruby
config = MangoApps::Config.new(
  domain: "yourdomain.mangoapps.com",
  client_id: "your_client_id",
  client_secret: "your_client_secret",
  redirect_uri: "https://localhost:3000/oauth/callback",
  scope: "openid profile email",
  timeout: 30,
  open_timeout: 10,
  logger: Logger.new(STDOUT)
)
```


## Development

### For SDK Users

If you're using this SDK in your application, you only need:

1. **Install the gem**: `gem install mangoapps-sdk`
2. **Configure OAuth**: Set up your MangoApps OAuth credentials
3. **Start coding**: Use the examples above

### For SDK Developers

If you're contributing to or extending this SDK, see our comprehensive developer documentation:

📚 **[DEVELOPER.md](DEVELOPER.md)** - Complete guide for SDK development including:
- Adding new APIs and modules
- Testing guidelines (real TDD approach)
- Development workflow
- Code style and standards
- Module architecture
- Error handling
- Documentation standards
- Release process

### Quick Development Setup

```bash
git clone https://github.com/MangoAppsInc/mangoapps-sdk.git
cd mangoapps-sdk
cp .env.example .env
# Edit .env with your MangoApps credentials (for testing only)
bundle install
```

### Testing the SDK

This SDK uses **real TDD** - no mocking, only actual OAuth testing:

```bash
# Get OAuth token (first time or when expired)
./run_auth.sh

# Run tests
./run_tests.sh

# Run specific module tests
./run_tests.sh learn
./run_tests.sh users  
./run_tests.sh recognitions
./run_tests.sh notifications
./run_tests.sh feeds
./run_tests.sh posts

# Interactive testing
./run_irb.sh
```

### Current API Coverage

- ✅ **Learn Module**: Course catalog, categories, course details, and my learning (4 endpoints)
- ✅ **Users Module**: User profile and authentication (1 endpoint)
- ✅ **Recognitions Module**: Award categories, get awards list, get profile awards, get team awards, core value tags, leaderboard info, tango gift cards, and gift cards (8 endpoints)
- ✅ **Notifications Module**: My priority items for requests, events, quizzes, surveys, tasks, and todos (1 endpoint)
- ✅ **Feeds Module**: User activity feeds with unread counts and feed details (1 endpoint)
- ✅ **Posts Module**: Get all posts with filtering options and get post by ID (2 endpoints)
- ✅ **Libraries Module**: Get user's document libraries with categories and items, get library categories by ID, and get library items by library and category ID (3 endpoints)
- ✅ **Trackers Module**: Get user's trackers with submission dates and conversation details (1 endpoint)
- ✅ **Attachments Module**: Get user's file folders with permissions and metadata, and get files and folders inside specific folders (2 endpoints)
- ✅ **Error Handling**: Comprehensive error logging and testing
- ✅ **OAuth Flow**: Token management and refresh

**Total: 23 API endpoints across 9 modules**

## Contributing

1. Fork the repository
2. Create a feature branch
3. Write real tests first (no mocking)
4. Implement the feature
5. Ensure all tests pass
6. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- **Documentation**: [RubyDoc](https://rubydoc.info/gems/mangoapps-sdk)
- **Issues**: [GitHub Issues](https://github.com/MangoAppsInc/mangoapps-sdk/issues)
- **MangoApps**: [Official Website](https://www.mangoapps.com)

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a list of changes and version history.