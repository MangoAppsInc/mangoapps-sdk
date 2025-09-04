# MangoApps Ruby SDK

A clean, **real TDD** Ruby SDK for MangoApps APIs with OAuth2/OpenID Connect authentication. No mocking - only actual OAuth testing with real MangoApps credentials.

## Features

- 🔐 **OAuth2/OpenID Connect** authentication with automatic token refresh
- 🚀 **Simple API** with intuitive method names
- 🧪 **Real TDD** - no mocking, only actual OAuth testing
- 🔄 **Automatic retries** with exponential backoff
- 📝 **Comprehensive error handling** with specific exception types
- 🛡️ **Security-first** design with PKCE support
- 🔧 **Environment variable configuration** for secure credentials
- 📚 **Well-documented** with examples and guides

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

Create a `.env` file with your MangoApps credentials:

```bash
# .env
MANGOAPPS_DOMAIN=yourdomain.mangoapps.com
MANGOAPPS_CLIENT_ID=your_client_id_here
MANGOAPPS_CLIENT_SECRET=your_client_secret_here
MANGOAPPS_REDIRECT_URI=https://localhost:3000/oauth/callback
MANGOAPPS_SCOPE=openid profile email
```

### 2. Configuration

```ruby
require "mangoapps"

# Automatically loads from .env file
config = MangoApps::Config.new

# Or override specific values
config = MangoApps::Config.new(
  domain: "custom.mangoapps.com"
  # Other values loaded from .env
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
client.authenticate!(authorization_code: params[:code])

# Now you can make API calls
posts = client.posts_list
```

## API Resources

### Users Module

```ruby
# Get current user profile
user = client.me

# Access user data
puts "User: #{user['ms_response']['user']['name']}"
puts "Email: #{user['ms_response']['user']['email']}"
puts "Points: #{user['ms_response']['user']['total_points']}"
```

### Learn Module

#### Course Catalog
```ruby
# Get course catalog
courses = client.course_catalog

# Access course data
courses["ms_response"]["courses"].each do |course|
  puts "#{course['name']} - #{course['course_type']}"
end
```

#### Course Categories
```ruby
# Get all course categories
categories = client.course_categories

# Access category data
categories["ms_response"]["all_categories"].each do |category|
  puts "#{category['name']} - Position: #{category['position']}"
end

# Get specific category details
category = client.course_category(category_id)
```

## Available Modules

### ✅ Currently Implemented

#### Users Module
- **User Profile**: `client.me` - Get current user information

#### Learn Module  
- **Course Catalog**: `client.course_catalog` - Get available courses
- **Course Categories**: `client.course_categories` - Get course categories


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

## Token Storage

The SDK automatically handles token storage and refresh:

```ruby
# Check if authenticated
if client.authenticated?
  # Make API calls
  posts = client.posts_list
else
  # Redirect to authorization
  auth_url = client.authorization_url
end

# Manual token refresh
client.refresh_token! if client.access_token.expired?
```

## Development

### Setup

```bash
git clone https://github.com/MangoAppsInc/mangoapps-sdk.git
cd mangoapps-sdk
cp .env.example .env
# Edit .env with your MangoApps credentials
bundle install
```

### Real TDD Testing

This SDK uses **real TDD** - no mocking, only actual OAuth testing with separated workflows:

#### OAuth Flow (Get Token)
```bash
# Get fresh OAuth token (interactive)
./run_auth.sh
```

#### API Testing (Fast Development)
```bash
# Run API tests (requires valid token in .env)
./run_tests.sh
```

#### Manual Testing
```bash
# Run all tests
bundle exec rspec spec/mangoapps/ --format documentation

# Run specific module tests
bundle exec rspec spec/mangoapps/learn_spec.rb --format documentation
bundle exec rspec spec/mangoapps/users_spec.rb --format documentation
```

### Development Workflow

1. **First time**: `./run_auth.sh` (get OAuth token)
2. **Development**: `./run_tests.sh` (run tests quickly)
3. **Token expires**: `./run_auth.sh` (get fresh token)

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
ruby generate_module.rb Files

# This creates:
# - lib/mangoapps/modules/files.rb
# - spec/mangoapps/files_spec.rb
# - Updates lib/mangoapps.rb and run_tests.sh
```

#### Manual Module Creation
1. Create module file: `lib/mangoapps/modules/your_module.rb`
2. Create test file: `spec/mangoapps/your_module_spec.rb`
3. Update `lib/mangoapps.rb` to include the module
4. Update `run_tests.sh` to run the new tests

See [MODULE_DEVELOPMENT.md](MODULE_DEVELOPMENT.md) for detailed guidelines.

### Current Test Coverage

- ✅ **Learn Module**: Course catalog and categories
- ✅ **Users Module**: User profile and authentication
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