# MangoApps SDK - AI Assistant Instructions

This document provides comprehensive instructions for AI assistants working on the MangoApps SDK project.

## Project Context

The MangoApps SDK is a Ruby gem that provides a clean, **real TDD** interface for interacting with MangoApps APIs. It uses OAuth2/OpenID Connect for authentication and follows strict **Real TDD** principles with no mocking - only actual OAuth testing with real MangoApps credentials.

## Core Principles

### 1. Real Test-Driven Development (TDD)
- **ALWAYS** write real tests before implementation (no mocking)
- Follow Red → Green → Refactor cycle
- Tests must be comprehensive and cover edge cases
- Use actual MangoApps API with real OAuth credentials
- Test against real MangoApps domain

### 2. Incremental Development
- Add one resource at a time
- Don't scaffold unused files
- Focus on making tests pass first
- Refactor only after tests are green

### 3. Clean Architecture
- Modular resource classes
- Separation of concerns
- Proper error handling
- Consistent naming conventions

## Technology Stack

- **Language**: Ruby (>= 3.0)
- **Testing**: RSpec + WebMock
- **HTTP Client**: Faraday with retry middleware
- **Authentication**: OAuth2 + OIDC discovery
- **Package Manager**: Bundler + RubyGems

## File Structure

```
mangoapps-sdk/
├── .cursor/                    # Cursor AI configuration
│   ├── prompts/               # Reusable prompts
│   └── instructions.md        # This file
├── .vscode/                   # VS Code settings
├── lib/                       # Main library code
│   ├── mangoapps.rb          # Entry point
│   ├── mangoapps/
│   │   ├── config.rb         # Configuration
│   │   ├── client.rb         # HTTP client
│   │   ├── oauth.rb          # OAuth2/OIDC
│   │   └── resources/        # API resources
│   │       └── posts.rb      # Posts resource
├── spec/                      # Test files
│   ├── spec_helper.rb        # Test configuration
│   └── mangoapps/
│       └── resources/
│           └── posts_spec.rb # Posts tests
├── .cursorrules              # Cursor AI rules
└── README.md                 # Documentation
```

## Development Workflow

### 1. Adding New Resources
When adding a new resource (e.g., Files, Users):

1. **Create Test File First**:
   - Use `.cursor/prompts/add-new-resource.md` as template
   - Stub HTTP requests with WebMock
   - Test both success and error cases
   - Mock access tokens

2. **Run Tests** (should fail):
   ```bash
   bundle exec rspec spec/mangoapps/resources/new_resource_spec.rb
   ```

3. **Implement Minimal Code**:
   - Create resource module
   - Include in main module
   - Make tests pass

4. **Refactor**:
   - Improve code while keeping tests green
   - Add error handling
   - Optimize performance

### 2. Debugging Test Failures
Common issues and solutions:

- **WebMock URL Mismatch**: Ensure stubs match exact URLs
- **Authorization Issues**: Always stub `access_token` method
- **Faraday URL Joining**: Ensure API base URL ends with `/`
- **JSON Parsing**: Use `.to_json` on response bodies

Use `.cursor/prompts/debug-test-failure.md` for detailed debugging help.

### 3. OAuth2/OIDC Setup
For authentication setup:

- Use OIDC discovery endpoint
- Implement PKCE for security
- Handle token refresh
- Store tokens securely

Use `.cursor/prompts/oauth-setup.md` for OAuth guidance.

## Code Style Guidelines

### Ruby Style
- Use `# frozen_string_literal: true` at top of files
- Follow Ruby style guide
- Use meaningful variable names
- Keep methods small and focused
- Add comments for complex logic

### Test Style
- Use descriptive test names
- Group related tests with `describe` blocks
- Use `let` for test data
- Mock external dependencies
- Assert on both request and response

### Error Handling
- Use custom exception classes
- Provide meaningful error messages
- Log errors when appropriate
- Handle HTTP errors gracefully

## Common Patterns

### Resource Module Pattern
```ruby
module MangoApps
  class Client
    module ResourceName
      def resource_list(params = {})
        get("resource", params: params)
      end

      def resource_create(**params)
        post("resource", body: params)
      end

      def resource_get(id)
        get("resource/#{id}")
      end

      def resource_update(id, **params)
        put("resource/#{id}", body: params)
      end

      def resource_delete(id)
        delete("resource/#{id}")
      end
    end
  end
end
```

### Test Pattern
```ruby
RSpec.describe "MangoApps::Client::ResourceName" do
  let(:client) { MangoApps::Client.new(config) }

  before do
    allow(client).to receive(:access_token)
      .and_return(double(token: "testtoken"))
  end

  describe "#resource_list" do
    it "GETs /resource with proper headers" do
      stub_request(:get, "https://domain.mangoapps.com/api/resource")
        .with(headers: { "Authorization" => "Bearer testtoken" })
        .to_return(status: 200, body: { "data" => [] }.to_json)

      result = client.resource_list
      expect(result).to include("data")
    end
  end
end
```

## Security Considerations

### OAuth2 Security
- Never commit API keys or secrets
- Use environment variables for sensitive data
- Implement PKCE for public clients
- Validate state parameter to prevent CSRF
- Use HTTPS for all OAuth endpoints

### Input Validation
- Validate all inputs
- Sanitize user data
- Use parameterized queries
- Handle malformed responses

### Token Management
- Store tokens securely (encrypted)
- Implement token refresh
- Handle token expiration
- Use secure token storage

## Performance Guidelines

### HTTP Client
- Use connection pooling
- Implement retry logic
- Set appropriate timeouts
- Handle rate limiting

### Memory Management
- Avoid memory leaks
- Use lazy loading where appropriate
- Clean up resources
- Monitor memory usage

## Documentation Standards

### Code Documentation
- Document public APIs
- Add examples for complex methods
- Explain business logic
- Keep documentation up to date

### README Updates
- Document new features
- Provide usage examples
- Update installation instructions
- Include troubleshooting section

### Changelog
- Document breaking changes
- List new features
- Note bug fixes
- Include migration guides

## Testing Standards

### Test Coverage
- Aim for high test coverage
- Test edge cases
- Test error conditions
- Test integration scenarios

### Test Quality
- Use descriptive test names
- Keep tests focused
- Avoid test duplication
- Use proper assertions

### Test Performance
- Keep tests fast
- Use mocks for external dependencies
- Avoid flaky tests
- Run tests in parallel when possible

## Common Commands

### Development
```bash
# Run tests
bundle exec rspec

# Run specific test
bundle exec rspec spec/mangoapps/resources/posts_spec.rb

# Run with documentation
bundle exec rspec --format documentation

# Run linter
bundle exec rubocop

# Install dependencies
bundle install
```

### Debugging
```bash
# Run single test with backtrace
bundle exec rspec spec/mangoapps/resources/posts_spec.rb:25 --backtrace

# Check gem dependencies
bundle show

# Test gem build
gem build mangoapps-sdk.gemspec
```

## AI Assistant Guidelines

When helping with this project:

1. **Always follow TDD approach**
2. **Suggest incremental improvements**
3. **Focus on testability and maintainability**
4. **Provide working code examples**
5. **Explain reasoning behind decisions**
6. **Help with debugging test failures**
7. **Suggest next steps for development**
8. **Maintain consistency with existing code**
9. **Consider security implications**
10. **Document complex logic**

## Troubleshooting

### Common Issues
- **URL joining problems**: Check trailing slashes in config
- **WebMock stubs not matching**: Verify exact URLs and headers
- **Authorization failures**: Ensure access tokens are stubbed
- **JSON parsing errors**: Use `.to_json` on response bodies
- **Module inclusion issues**: Check include statements

### Getting Help
- Check `.cursor/prompts/` for specific guidance
- Review existing tests for patterns
- Use debugging prompts for test failures
- Consult OAuth setup guide for authentication issues

Remember: This is a TDD-first project. Always write tests before implementation!
