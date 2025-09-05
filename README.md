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

## Complete Examples

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

# Interactive testing
./run_irb.sh
```

### Current API Coverage

- ✅ **Learn Module**: Course catalog, categories, course details, and my learning
- ✅ **Users Module**: User profile and authentication  
- ✅ **Recognitions Module**: Award categories, get awards list, get profile awards, get team awards, core value tags, leaderboard info, tango gift cards, and gift cards
- ✅ **Error Handling**: Comprehensive error logging and testing
- ✅ **OAuth Flow**: Token management and refresh

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