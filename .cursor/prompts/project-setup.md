# Project Setup - MangoApps SDK

Use this prompt when setting up the project for the first time or onboarding new developers.

## Initial Setup

### 1. Clone and Install Dependencies
```bash
git clone <repository-url>
cd mangoapps-sdk
bundle install
```

### 2. Verify Installation
```bash
# Run tests to ensure everything works
bundle exec rspec

# Check gem can be built
gem build mangoapps-sdk.gemspec
```

### 3. Development Environment
```bash
# Install development dependencies
bundle install

# Run linter
bundle exec rubocop

# Run tests with coverage
bundle exec rspec --format documentation
```

## Project Structure

```
mangoapps-sdk/
├── .cursor/                    # Cursor AI configuration
│   └── prompts/               # Reusable prompts
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
├── .gitignore               # Git ignore rules
├── Gemfile                  # Dependencies
├── mangoapps-sdk.gemspec    # Gem specification
└── README.md               # Documentation
```

## Development Workflow

### 1. TDD Workflow
```bash
# 1. Write test first
# Edit spec/mangoapps/resources/new_resource_spec.rb

# 2. Run test (should fail)
bundle exec rspec spec/mangoapps/resources/new_resource_spec.rb

# 3. Implement minimal code
# Edit lib/mangoapps/resources/new_resource.rb

# 4. Run test (should pass)
bundle exec rspec

# 5. Refactor and ensure tests still pass
bundle exec rspec
```

### 2. Adding New Resources
Use the `.cursor/prompts/add-new-resource.md` prompt for step-by-step instructions.

### 3. Debugging Tests
Use the `.cursor/prompts/debug-test-failure.md` prompt for common issues.

## Configuration

### Environment Variables
```bash
# Optional: Set up environment variables
export MANGOAPPS_DOMAIN=yourdomain.mangoapps.com
export MANGOAPPS_CLIENT_ID=your_client_id
export MANGOAPPS_CLIENT_SECRET=your_client_secret
export MANGOAPPS_REDIRECT_URI=http://localhost:3000/callback
```

### Local Development
```ruby
# Example usage in development
require './lib/mangoapps'

config = MangoApps::Config.new(
  domain: ENV['MANGOAPPS_DOMAIN'] || 'yourdomain.mangoapps.com',
  client_id: ENV['MANGOAPPS_CLIENT_ID'] || 'test_client_id',
  client_secret: ENV['MANGOAPPS_CLIENT_SECRET'] || 'test_client_secret',
  redirect_uri: ENV['MANGOAPPS_REDIRECT_URI'] || 'http://localhost:3000/callback'
)

client = MangoApps::Client.new(config)
```

## Testing

### Run All Tests
```bash
bundle exec rspec
```

### Run Specific Test
```bash
bundle exec rspec spec/mangoapps/resources/posts_spec.rb
```

### Run with Documentation
```bash
bundle exec rspec --format documentation
```

### Run with Coverage
```bash
# If using SimpleCov
bundle exec rspec
open coverage/index.html
```

## Code Quality

### Linting
```bash
bundle exec rubocop
```

### Auto-fix Linting Issues
```bash
bundle exec rubocop -a
```

### Security Check
```bash
bundle audit
```

## Building and Publishing

### Build Gem
```bash
gem build mangoapps-sdk.gemspec
```

### Install Locally
```bash
gem install mangoapps-sdk-0.1.0.gem
```

### Publish to RubyGems
```bash
gem push mangoapps-sdk-0.1.0.gem
```

## Common Commands

### Development
```bash
# Run tests
bundle exec rspec

# Run linter
bundle exec rubocop

# Install dependencies
bundle install

# Update dependencies
bundle update
```

### Debugging
```bash
# Run single test with backtrace
bundle exec rspec spec/mangoapps/resources/posts_spec.rb:25 --backtrace

# Run with verbose output
bundle exec rspec --format documentation

# Check gem dependencies
bundle show
```

### Git Workflow
```bash
# Create feature branch
git checkout -b feature/add-files-resource

# Commit changes
git add .
git commit -m "feat: add files resource with list and create methods"

# Push branch
git push origin feature/add-files-resource
```

## Troubleshooting

### Bundle Issues
```bash
# Clear bundle cache
bundle clean --force

# Reinstall dependencies
rm Gemfile.lock
bundle install
```

### Test Issues
```bash
# Clear test cache
rm -rf .rspec_status

# Run tests with clean state
bundle exec rspec
```

### Gem Issues
```bash
# Uninstall and reinstall
gem uninstall mangoapps-sdk
gem install mangoapps-sdk-0.1.0.gem
```

## IDE Setup

### VS Code Extensions
- Ruby
- Ruby Solargraph
- RSpec
- GitLens

### Cursor AI
The project includes `.cursorrules` and `.cursor/prompts/` for AI assistance.

### Ruby Version
Ensure you're using Ruby >= 3.0:
```bash
ruby --version
# Should be 3.0 or higher
```

## Contributing

### Code Style
- Follow Ruby style guide
- Use `# frozen_string_literal: true`
- Write descriptive commit messages
- Add tests for new features

### Pull Request Process
1. Create feature branch
2. Write tests first (TDD)
3. Implement feature
4. Ensure all tests pass
5. Run linter
6. Create pull request

### Commit Convention
```
feat: add new feature
fix: bug fix
docs: documentation update
test: add or update tests
refactor: code refactoring
chore: maintenance tasks
```
