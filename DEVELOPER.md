# MangoApps SDK - Developer Documentation

This document provides comprehensive guidelines for developers working on the MangoApps Ruby SDK, including creating, updating, and adding new APIs.

## Table of Contents

- [Development Philosophy](#development-philosophy)
- [Project Structure](#project-structure)
- [Adding New APIs](#adding-new-apis)
- [Testing Guidelines](#testing-guidelines)
- [Development Workflow](#development-workflow)
- [Code Style & Standards](#code-style--standards)
- [Module Architecture](#module-architecture)
- [Error Handling](#error-handling)
- [Documentation Standards](#documentation-standards)
- [Release Process](#release-process)
- [Troubleshooting](#troubleshooting)

## Development Philosophy

### Core Principles
- **Real TDD First**: Always write real tests before implementation (no mocking)
- **Incremental Development**: Add one resource at a time
- **Clean Architecture**: Modular, testable code
- **OAuth2/OIDC**: Proper authentication flow with real credentials
- **Faraday HTTP**: With retries and JSON handling
- **Environment Variables**: Secure credential management
- **Clean Response API**: Automatic response wrapping with intuitive dot notation access

### Technology Stack
- **Language**: Ruby (>= 3.0)
- **Testing**: RSpec (real tests only, no mocking)
- **HTTP Client**: Faraday with retry middleware
- **Authentication**: OAuth2 + OIDC discovery
- **Configuration**: Environment variables with dotenv
- **Package Manager**: Bundler + RubyGems

## Project Structure

```
mangoapps-sdk/
├── lib/
│   ├── mangoapps.rb              # Main module
│   ├── mangoapps/config.rb       # Configuration
│   ├── mangoapps/client.rb       # HTTP client
│   ├── mangoapps/oauth.rb        # OAuth2/OIDC
│   ├── mangoapps/response.rb     # Response wrapper for clean dot notation
│   ├── mangoapps/errors.rb       # Error classes
│   ├── mangoapps/version.rb      # Version info
│   └── mangoapps/modules/        # API modules
│       ├── learn.rb              # Learn module
│       ├── users.rb              # Users module
│       ├── recognitions.rb       # Recognitions module
│       └── learn/                # Learn sub-modules
│           ├── course_catalog.rb # Course catalog
│           └── course_categories.rb # Course categories
├── spec/
│   ├── real_spec_helper.rb       # RSpec configuration (real tests only)
│   ├── shared_test_helpers.rb    # Reusable test helpers
│   ├── module_template.rb        # Template for new module tests
│   └── mangoapps/
│       ├── learn_spec.rb         # Learn module tests
│       ├── users_spec.rb         # Users module tests
│       └── recognitions_spec.rb  # Recognitions module tests
├── run_auth.sh                   # OAuth flow script
├── run_tests.sh                  # API test runner
├── generate_module.rb            # Module generator script
├── MODULES.md                    # Development guidelines
├── .env                          # Environment variables (credentials)
├── .env.example                  # Environment template
└── .cursorrules                  # AI configuration
```

## Adding New APIs

### Quick Start - Using the Module Generator (Recommended)

```bash
# Generate a new module with tests
ruby generate_module.rb ModuleName endpoint_method response_key

# Example:
ruby generate_module.rb Files files_list files
```

This creates:
- `lib/mangoapps/modules/files.rb`
- `spec/mangoapps/files_spec.rb`
- Updates `lib/mangoapps.rb` and `run_tests.sh`

### Manual Module Creation

#### 1. Create the Module File

For **Learn Module** resources:
```ruby
# lib/mangoapps/modules/learn/new_resource.rb
module MangoApps
  class Client
    module Learn
      module NewResource
        def new_learn_endpoint(params = {})
          get("v2/learn/new_endpoint.json", params: params)
        end
      end
    end
  end
end
```

For **Core API** resources:
```ruby
# lib/mangoapps/modules/your_module.rb
module MangoApps
  class Client
    module YourModule
      def your_endpoint(params = {})
        get("v2/your_endpoint.json", params: params)
      end
    end
  end
end
```

#### 2. Include the Module

For **Learn Module**:
```ruby
# lib/mangoapps/modules/learn.rb
require_relative "learn/new_resource"
module MangoApps
  class Client
    module Learn
      include MangoApps::Client::Learn::NewResource
    end
  end
end
```

For **Core APIs**:
```ruby
# lib/mangoapps.rb
require_relative "mangoapps/modules/your_module"
MangoApps::Client.include(MangoApps::Client::YourModule)
```

#### 3. Add Tests

Use the module template:
```bash
cp spec/module_template.rb spec/mangoapps/your_module_spec.rb
```

Then customize the template by replacing placeholders:
- `[MODULE_NAME]` → Your module name (e.g., "Files")
- `[ENDPOINT_METHOD]` → Your API method (e.g., "files_list")
- `[RESPONSE_KEY]` → Expected response key (e.g., "files")
- `[FEATURE_NAME]` → Feature description (e.g., "File Management")

### For Recognitions Module Resources

The recognitions module uses a folder structure similar to the learn module:

1. **Create Resource Module**:
```ruby
# lib/mangoapps/modules/recognitions/new_resource.rb
module MangoApps
  class Client
    module Recognitions
      module NewResource
        def new_recognitions_endpoint(params = {})
          get("v2/recognitions/new_endpoint.json", params: params)
        end
      end
    end
  end
end
```

2. **Include in Main Module**:
```ruby
# lib/mangoapps/modules/recognitions.rb
require_relative "recognitions/new_resource"
module MangoApps
  class Client
    module Recognitions
      include MangoApps::Client::Recognitions::NewResource
    end
  end
end
```

3. **Add Test to Recognitions Spec**:
```ruby
# Add to spec/mangoapps/recognitions_spec.rb
describe "New Recognitions Resource" do
  it "tests new recognitions API endpoint" do
    puts "\n🏆 Testing Recognitions API - New Resource..."
    
    response = client.new_recognitions_endpoint
    
    expect(response).to be_a(MangoApps::Response)
    expect(response).to respond_to(:expected_key)
    puts "✅ New Recognitions API call successful!"
    puts "📊 Response contains expected data structure"
  end
end
```

## Testing Guidelines

### Real TDD Approach

**CRITICAL**: This project uses **real TDD** - no mocking, only actual OAuth testing with real MangoApps API calls.

#### Test Structure
```ruby
describe "Your API" do
  it "tests your API endpoint" do
    puts "\n🔍 Testing Your API..."
    
    response = client.your_endpoint
    
    expect(response).to be_a(MangoApps::Response) # Clean response wrapper
    expect(response).to respond_to(:expected_key)
    puts "✅ Your API call successful!"
    puts "📊 Response contains expected data"
  end
end
```

#### Test Validation
- Use `respond_to?` instead of `have_key` for response validation
- Test against actual MangoApps domain
- Assert on real API responses with clean dot notation access
- Keep tests simple and focused on functionality
- Validate response structure using dot notation

#### Running Tests

```bash
# Run all tests
./run_tests.sh

# Run specific module tests
./run_tests.sh learn
./run_tests.sh users
./run_tests.sh recognitions

# Run individual test files
bundle exec rspec spec/mangoapps/your_module_spec.rb --format documentation
```

### Test Response Format

All tests validate the clean response format:
```ruby
# Tests validate MangoApps::Response objects
expect(response).to be_a(MangoApps::Response)
expect(response).to respond_to(:user_profile)

# Clean dot notation access in tests
user_profile = response.user_profile
expect(user_profile).to respond_to(:minimal_profile)
```

## Development Workflow

### 1. OAuth Setup
```bash
# Get fresh OAuth token (interactive)
./run_auth.sh
```

### 2. Development Cycle
```bash
# Run tests (should fail initially)
./run_tests.sh

# Implement minimal code to make tests pass
# Run tests again
./run_tests.sh

# Refactor while keeping tests green
# Run tests to verify
./run_tests.sh
```

### 3. Interactive Testing
```bash
# Start interactive Ruby shell with SDK loaded
./run_irb.sh
```

### 4. Token Management
```bash
# When token expires, get fresh token
./run_auth.sh

# Then continue with fast testing
./run_tests.sh
```

## Code Style & Standards

### File Headers
```ruby
# frozen_string_literal: true
```

### Method Naming
- Use snake_case for method names
- Be descriptive: `get_awards_list` not `get_awards`
- Include resource type: `course_catalog` not `catalog`

### Parameter Handling
```ruby
def your_endpoint(params = {})
  get("v2/your_endpoint.json", params: params)
end
```

### Error Handling
```ruby
begin
  response = client.your_endpoint
rescue MangoApps::APIError => e
  puts "API error: #{e.message}"
  puts "Status: #{e.status_code}"
end
```

## Module Architecture

### Module Organization

#### Flat Modules (Users, etc.)
```ruby
# lib/mangoapps/modules/users.rb
module MangoApps
  class Client
    module Users
      def me(params = {})
        get("v2/users/me.json", params: params)
      end
    end
  end
end
```

#### Hierarchical Modules (Learn, Recognitions)
```ruby
# lib/mangoapps/modules/learn.rb
require_relative "learn/course_catalog"
require_relative "learn/course_categories"

module MangoApps
  class Client
    module Learn
      include MangoApps::Client::Learn::CourseCatalog
      include MangoApps::Client::Learn::CourseCategories
    end
  end
end
```

### Response Handling

All API responses are automatically wrapped in `MangoApps::Response` objects:

```ruby
# Clean dot notation access
user = client.me
name = user.user_profile.minimal_profile.name

# Still supports hash access if needed
name = user["user_profile"]["minimal_profile"]["name"]
```

## Error Handling

### Exception Types
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

### Error Handling Best Practices
```ruby
begin
  response = client.your_endpoint
rescue MangoApps::AuthenticationError => e
  # Handle authentication issues
  puts "Authentication failed: #{e.message}"
rescue MangoApps::APIError => e
  # Handle general API errors
  puts "API error: #{e.message}"
  puts "Status: #{e.status_code}"
rescue MangoApps::RateLimitError => e
  # Handle rate limiting
  puts "Rate limited: #{e.message}"
  # Implement backoff strategy
end
```

## Documentation Standards

### README Updates
When adding new APIs, update:
1. **API Resources section** - Add new endpoint documentation
2. **Available Modules section** - List new endpoints
3. **Complete Examples section** - Add usage examples
4. **Test Coverage section** - Update test counts

### CHANGELOG Updates
Follow [Keep a Changelog](https://keepachangelog.com/) format:
```markdown
## [0.2.X] - YYYY-MM-DD

### Added
- **New API** in Module
  - `client.new_endpoint` - Description of functionality
  - Access to specific data fields
  - Clean dot notation access examples

### Enhanced
- **Test Coverage** - Added comprehensive test for new API
- **Documentation** - Updated README with new API examples
```

### Version Updates
Update version in `lib/mangoapps/version.rb`:
```ruby
VERSION = "0.2.X"
```

## Release Process

### Pre-Release Checklist
- [ ] All tests pass (`./run_tests.sh`)
- [ ] OAuth flow works (`./run_auth.sh`)
- [ ] Documentation updated (README, CHANGELOG)
- [ ] Version bumped in version.rb
- [ ] Gem builds successfully (`gem build mangoapps-sdk.gemspec`)

### Building and Publishing
```bash
# Build the gem
gem build mangoapps-sdk.gemspec

# Publish to RubyGems (if authorized)
gem push mangoapps-sdk-0.2.X.gem
```

## Troubleshooting

### Common Issues

#### Token Expiration
```bash
# Get fresh token
./run_auth.sh

# Then run tests
./run_tests.sh
```

#### Test Failures
1. Check if OAuth token is valid
2. Verify API endpoint URL is correct
3. Check response structure matches expectations
4. Ensure proper error handling

#### Module Loading Issues
1. Verify require statements in main module files
2. Check module inclusion in client
3. Ensure file paths are correct

#### Response Structure Issues
1. Test API endpoint manually to see actual response
2. Update test expectations to match real response
3. Use `respond_to?` for flexible validation

### Debugging Tips

#### Enable Verbose Logging
```ruby
config = MangoApps::Config.new(
  logger: Logger.new(STDOUT),
  log_level: :debug
)
```

#### Interactive Testing
```bash
# Use IRB for quick testing
./run_irb.sh

# Then test your API
client = MangoApps::Client.new(config)
response = client.your_endpoint
puts response.inspect
```

#### Check Response Structure
```ruby
# Inspect raw response
puts response.raw_data.inspect

# Check available methods
puts response.methods.grep(/your_expected_key/)
```

## Best Practices

### API Design
- Keep method names descriptive and consistent
- Use standard HTTP methods appropriately
- Handle parameters consistently
- Provide meaningful error messages

### Testing
- Write tests first (TDD)
- Test real API responses, not mocks
- Validate response structure thoroughly
- Keep tests focused and readable

### Documentation
- Update README for user-facing changes
- Update CHANGELOG for all releases
- Include code examples in documentation
- Keep examples up-to-date with API changes

### Security
- Never commit API keys or secrets
- Use environment variables for sensitive data
- Validate all inputs
- Follow OAuth2 security best practices

## Contributing

1. Fork the repository
2. Create a feature branch
3. Write real tests first (no mocking)
4. Implement the feature
5. Ensure all tests pass
6. Update documentation
7. Submit a pull request

## Support

- **Issues**: [GitHub Issues](https://github.com/MangoAppsInc/mangoapps-sdk/issues)
- **Documentation**: This file and README.md
- **MangoApps API**: [Official Documentation](https://www.mangoapps.com)

---

**Remember**: This SDK uses real TDD with actual OAuth testing. Always test against the real MangoApps API to ensure authentic validation of your implementations.
