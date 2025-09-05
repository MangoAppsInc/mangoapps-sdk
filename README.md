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

### Setup

```bash
git clone https://github.com/MangoAppsInc/mangoapps-sdk.git
cd mangoapps-sdk
cp .env.example .env
# Edit .env with your MangoApps credentials (for testing only)
bundle install
```

### Real TDD Testing

This SDK uses **real TDD** - no mocking, only actual OAuth testing with separated workflows and clean response validation:

#### OAuth Flow (Get Token)
```bash
# Get fresh OAuth token (interactive)
./run_auth.sh
```

#### API Testing (Fast Development)
```bash
# Run all API tests (requires valid token in .env)
./run_tests.sh
./run_tests.sh all

# Run specific module tests
./run_tests.sh learn
./run_tests.sh users
./run_tests.sh recognitions

# Show help
./run_tests.sh help
```

#### Interactive API Testing
```bash
# Start interactive Ruby shell with SDK loaded
./run_irb.sh
```

#### Manual Testing
```bash
# Run all tests with clean response validation
bundle exec rspec spec/mangoapps/ --format documentation

# Run specific module tests
bundle exec rspec spec/mangoapps/learn_spec.rb --format documentation
bundle exec rspec spec/mangoapps/users_spec.rb --format documentation
bundle exec rspec spec/mangoapps/recognitions_spec.rb --format documentation
```

#### Test Response Format
All tests now validate the clean response format:
```ruby
# Tests validate MangoApps::Response objects
expect(response).to be_a(MangoApps::Response)
expect(response).to respond_to(:user_profile)

# Clean dot notation access in tests
user_profile = response.user_profile
expect(user_profile).to respond_to(:minimal_profile)
```

### Development Workflow

1. **First time**: `./run_auth.sh` (get OAuth token)
2. **Development**: `./run_tests.sh` (run tests quickly)
3. **Interactive testing**: `./run_irb.sh` (test APIs interactively)
4. **Token expires**: `./run_auth.sh` (get fresh token)

#### Benefits of Separated Workflow

- **⚡ Fast Testing**: No OAuth delay during development
- **🔒 Secure**: Always validates token before testing
- **🧹 Clean**: Single responsibility for each script
- **💡 Clear**: Helpful error messages and guidance
- **🎯 Focused**: OAuth and testing are completely separate

### Adding New Modules

The SDK uses a modular architecture that makes adding new APIs simple:

#### Using the Module Generator (Recommended)
```bash
# Generate a new module with tests
ruby generate_module.rb Files files_list files

# This creates:
# - lib/mangoapps/modules/files.rb
# - spec/mangoapps/files_spec.rb
# - Updates lib/mangoapps.rb and run_tests.sh
```

#### Manual Module Creation
1. **Copy the template**: `cp spec/module_template.rb spec/mangoapps/your_module_spec.rb`
2. **Replace placeholders** in the template:
   - `[MODULE_NAME]` → Your module name (e.g., "Files")
   - `[ENDPOINT_METHOD]` → Your API method (e.g., "files_list")
   - `[RESPONSE_KEY]` → Expected response key (e.g., "files")
   - `[FEATURE_NAME]` → Feature description (e.g., "File Management")
3. **Create module file**: `lib/mangoapps/modules/your_module.rb`
4. **Update includes**: Add to `lib/mangoapps.rb` and `run_tests.sh`

#### Module Template Structure
The `spec/module_template.rb` provides a clean, minimal template with:
- ✅ **Basic RSpec structure** with token validation
- ✅ **Single feature test example** using helper methods
- ✅ **Clear placeholder comments** for easy customization
- ✅ **Helper method usage** (`test_api_endpoint`, `validate_array_response`)
- ✅ **Clean response validation** with `MangoApps::Response` objects
- ✅ **Dot notation testing** for intuitive API access

See [MODULES.md](MODULES.md) for detailed guidelines.

### Current Test Coverage

- ✅ **Learn Module**: Course catalog, categories, course details, and my learning
- ✅ **Users Module**: User profile and authentication
- ✅ **Recognitions Module**: Award categories, core value tags, leaderboard info, tango gift cards, and gift cards
- ✅ **Error Handling**: Comprehensive error logging and testing
- ✅ **OAuth Flow**: Token management and refresh
- ✅ **Test Runner**: Module-specific testing with flexible command-line options

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