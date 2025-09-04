# MangoApps Ruby SDK

[![Gem Version](https://badge.fury.io/rb/mangoapps-sdk.svg)](https://badge.fury.io/rb/mangoapps-sdk)
[![Build Status](https://github.com/MangoAppsInc/mangoapps-sdk/workflows/CI/badge.svg)](https://github.com/MangoAppsInc/mangoapps-sdk/actions)
[![Code Climate](https://codeclimate.com/github/MangoAppsInc/mangoapps-sdk/badges/gpa.svg)](https://codeclimate.com/github/MangoAppsInc/mangoapps-sdk)

A clean, test-driven Ruby SDK for MangoApps APIs with OAuth2/OpenID Connect authentication. This gem provides easy-to-use methods for interacting with MangoApps REST APIs including posts, files, users, and more.

## Features

- 🔐 **OAuth2/OpenID Connect** authentication with automatic token refresh
- 🚀 **Simple API** with intuitive method names
- 🧪 **Test-driven development** with comprehensive test coverage
- 🔄 **Automatic retries** with exponential backoff
- 📝 **Comprehensive error handling** with specific exception types
- 🛡️ **Security-first** design with PKCE support
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

### 1. Configuration

```ruby
require "mangoapps"

config = MangoApps::Config.new(
  domain:        "yourdomain.mangoapps.com",
  client_id:     ENV["MANGOAPPS_CLIENT_ID"],
  client_secret: ENV["MANGOAPPS_CLIENT_SECRET"],
  redirect_uri:  "http://localhost:3000/oauth/callback",
  scope:         "openid profile offline_access"
)

client = MangoApps::Client.new(config)
```

### 2. OAuth Authentication

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

### 3. API Usage

```ruby
# Create a post
post = client.posts_create(
  title: "Hello from Ruby SDK",
  content: "This is my first post using the MangoApps Ruby SDK!"
)

# List posts
posts = client.posts_list(limit: 10)

# Get specific post
post = client.posts_get(post["id"])
```

## OAuth2 Flow

The SDK supports the standard OAuth2 authorization code flow with PKCE for enhanced security.

### Basic Flow

```ruby
# 1. Generate authorization URL
state = SecureRandom.hex(16)
auth_url = client.authorization_url(state: state)

# 2. Redirect user to auth_url
# User authorizes and gets redirected back with code

# 3. Exchange code for tokens
client.authenticate!(authorization_code: params[:code])

# 4. Make API calls
posts = client.posts_list
```

### PKCE Flow (Recommended)

```ruby
require "securerandom"
require "digest"
require "base64"

# Generate PKCE parameters
code_verifier = Base64.urlsafe_encode64(SecureRandom.random_bytes(32), padding: false)
code_challenge = Base64.urlsafe_encode64(
  Digest::SHA256.digest(code_verifier),
  padding: false
)

# Generate authorization URL with PKCE
state = SecureRandom.hex(16)
auth_url = client.authorization_url(
  state: state,
  code_challenge: code_challenge,
  code_challenge_method: "S256"
)

# Exchange code with PKCE verifier
client.authenticate!(
  authorization_code: params[:code],
  code_verifier: code_verifier
)
```

## API Resources

### Posts

```ruby
# List posts
posts = client.posts_list(limit: 20, offset: 0)

# Create post
post = client.posts_create(
  title: "My Post",
  content: "Post content here",
  pin: true
)

# Get specific post
post = client.posts_get(123)

# Update post
updated_post = client.posts_update(123, title: "Updated Title")

# Delete post
client.posts_delete(123)
```

### Files (Coming Soon)

```ruby
# List files
files = client.files_list(folder_id: 456)

# Upload file
file = client.files_upload(
  file_path: "/path/to/file.pdf",
  folder_id: 456,
  description: "My uploaded file"
)

# Download file
file_content = client.files_download(789)
```

### Users (Coming Soon)

```ruby
# Get current user
user = client.users_me

# Get user by ID
user = client.users_get(123)

# Search users
users = client.users_search(query: "john")
```

## Error Handling

The SDK provides specific exception types for different error scenarios:

```ruby
begin
  posts = client.posts_list
rescue MangoApps::AuthenticationError => e
  puts "Authentication failed: #{e.message}"
rescue MangoApps::APIError => e
  puts "API error (#{e.status_code}): #{e.message}"
rescue MangoApps::RateLimitError => e
  puts "Rate limited: #{e.message}"
  # Wait and retry
rescue MangoApps::Error => e
  puts "SDK error: #{e.message}"
end
```

### Error Types

- `MangoApps::AuthenticationError` - Authentication/authorization issues
- `MangoApps::TokenExpiredError` - Access token expired
- `MangoApps::APIError` - General API errors
- `MangoApps::BadRequestError` - 400 Bad Request
- `MangoApps::UnauthorizedError` - 401 Unauthorized
- `MangoApps::ForbiddenError` - 403 Forbidden
- `MangoApps::NotFoundError` - 404 Not Found
- `MangoApps::RateLimitError` - 429 Rate Limited
- `MangoApps::ServerError` - 5xx Server Errors

## Configuration Options

```ruby
config = MangoApps::Config.new(
  domain:        "yourdomain.mangoapps.com",    # Required: Your MangoApps domain
  client_id:     "your_client_id",              # Required: OAuth client ID
  client_secret: "your_client_secret",          # Required: OAuth client secret
  redirect_uri:  "http://localhost:3000/cb",    # Required: OAuth redirect URI
  scope:         "openid profile offline_access", # Optional: OAuth scopes
  timeout:       30,                            # Optional: HTTP timeout (seconds)
  open_timeout:  10,                            # Optional: HTTP open timeout (seconds)
  logger:        Logger.new(STDOUT),            # Optional: Logger instance
  token_store:   MyTokenStore.new               # Optional: Custom token storage
)
```

## Token Storage

By default, tokens are not persisted. You can provide a custom token store:

```ruby
class FileTokenStore
  def initialize(file_path = "mangoapps_token.json")
    @file_path = file_path
  end

  def save(token_hash)
    File.write(@file_path, token_hash.to_json)
  end

  def load
    return nil unless File.exist?(@file_path)

    JSON.parse(File.read(@file_path))
  end
end

config = MangoApps::Config.new(
  domain: "yourdomain.mangoapps.com",
  client_id: "your_client_id",
  client_secret: "your_client_secret",
  redirect_uri: "http://localhost:3000/cb",
  token_store: FileTokenStore.new
)
```

## Development

### Setup

```bash
git clone https://github.com/MangoAppsInc/mangoapps-sdk.git
cd mangoapps-sdk
bundle install
```

### Running Tests

```bash
# Run all tests
bundle exec rspec

# Run with coverage
bundle exec rspec --format documentation

# Run specific test
bundle exec rspec spec/mangoapps/resources/posts_spec.rb
```

### Code Quality

```bash
# Run linter
bundle exec rubocop

# Auto-fix issues
bundle exec rubocop -a
```

### Building the Gem

```bash
gem build mangoapps-sdk.gemspec
gem install mangoapps-sdk-0.1.0.gem
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Write tests for your changes
4. Ensure all tests pass (`bundle exec rspec`)
5. Run the linter (`bundle exec rubocop`)
6. Commit your changes (`git commit -m 'Add amazing feature'`)
7. Push to the branch (`git push origin feature/amazing-feature`)
8. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- 📧 Email: support@mangoapps.com
- 🐛 Issues: [GitHub Issues](https://github.com/MangoAppsInc/mangoapps-sdk/issues)
- 📚 Documentation: [RubyDoc](https://rubydoc.info/gems/mangoapps-sdk)
- 🌐 Website: [MangoApps](https://www.mangoapps.com)

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a list of changes and version history.
