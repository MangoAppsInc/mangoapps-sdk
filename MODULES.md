# Module Development Guide

This guide explains how to add new API modules to the MangoApps SDK using our **real TDD** approach with clean response validation.

## Overview

The MangoApps SDK uses a modular architecture that makes adding new APIs simple and consistent. Each module follows the same pattern:

1. **Real TDD First** - Write tests before implementation (no mocking)
2. **Clean Response API** - Automatic response wrapping with dot notation
3. **Incremental Development** - Add one resource at a time
4. **Consistent Structure** - Follow established patterns

## Quick Start

### Using the Module Generator (Recommended)

```bash
# Generate a new module with tests
ruby generate_module.rb ModuleName endpoint_method response_key

# Example: Create a Files module
ruby generate_module.rb Files files_list files
```

This creates:
- `lib/mangoapps/modules/files.rb` - Module implementation
- `spec/mangoapps/files_spec.rb` - Test file
- Updates `lib/mangoapps.rb` and `run_tests.sh`

### Manual Module Creation

1. **Copy the template**: `cp spec/module_template.rb spec/mangoapps/your_module_spec.rb`
2. **Replace placeholders** in the template
3. **Create module file**: `lib/mangoapps/modules/your_module.rb`
4. **Update includes**: Add to `lib/mangoapps.rb` and `run_tests.sh`

## Module Template Structure

The `spec/module_template.rb` provides a clean, minimal template with:

- ✅ **Basic RSpec structure** with token validation
- ✅ **Single feature test example** using helper methods
- ✅ **Clear placeholder comments** for easy customization
- ✅ **Helper method usage** (`test_api_endpoint`, `validate_array_response`)
- ✅ **Clean response validation** with `MangoApps::Response` objects
- ✅ **Dot notation testing** for intuitive API access

## Development Workflow

### 1. OAuth Setup (First Time)

```bash
# Get fresh OAuth token (interactive)
./run_auth.sh
```

### 2. Create Module Tests

```ruby
# spec/mangoapps/your_module_spec.rb
require_relative "../real_spec_helper"

RSpec.describe MangoApps::Client::YourModule do
  include_context "with valid token"

  describe "Your API" do
    it "lists items from actual MangoApps API" do
      puts "\n🔍 Testing Your API..."
      
      response = client.your_endpoint
      
      expect(response).to be_a(MangoApps::Response)
      expect(response).to respond_to(:expected_key)
      puts "✅ Your API call successful!"
      puts "📊 Response contains expected data"
    end
  end
end
```

### 3. Run Tests (Should Fail)

```bash
# Run tests to see what needs to be implemented
./run_tests.sh
```

### 4. Implement Module

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

### 5. Include Module

```ruby
# lib/mangoapps.rb
require_relative "mangoapps/modules/your_module"
MangoApps::Client.include(MangoApps::Client::YourModule)
```

### 6. Update Test Runner

```bash
# Add to run_tests.sh
echo "🧪 Testing Your Module..."
bundle exec rspec spec/mangoapps/your_module_spec.rb --format documentation
```

### 7. Run Tests Again

```bash
# Should now pass
./run_tests.sh
```

## Module Patterns

### Basic Module Structure

```ruby
module MangoApps
  class Client
    module YourModule
      def your_endpoint(params = {})
        get("v2/your_endpoint.json", params: params)
      end
      
      def your_specific_item(id, params = {})
        get("v2/your_endpoint/#{id}.json", params: params)
      end
    end
  end
end
```

### Learn Module Sub-modules

For Learn module resources, create sub-modules:

```ruby
# lib/mangoapps/modules/learn/your_resource.rb
module MangoApps
  class Client
    module Learn
      module YourResource
        def your_learn_endpoint(params = {})
          get("v2/learn/your_endpoint.json", params: params)
        end
      end
    end
  end
end
```

Then include in the main Learn module:

```ruby
# lib/mangoapps/modules/learn.rb
require_relative "learn/your_resource"
module MangoApps
  class Client
    module Learn
      include MangoApps::Client::Learn::YourResource
    end
  end
end
```

## Test Patterns

### Basic Test Structure

```ruby
describe "Your API" do
  it "lists items from actual MangoApps API" do
    puts "\n🔍 Testing Your API..."
    
    response = client.your_endpoint
    
    expect(response).to be_a(MangoApps::Response)
    expect(response).to respond_to(:expected_key)
    puts "✅ Your API call successful!"
    puts "📊 Response contains expected data"
  end
end
```

### Array Response Testing

```ruby
describe "Your API" do
  it "returns array of items" do
    puts "\n🔍 Testing Your API..."
    
    response = client.your_endpoint
    
    expect(response).to be_a(MangoApps::Response)
    expect(response).to respond_to(:items)
    expect(response.items).to be_an(Array)
    puts "✅ Your API call successful!"
    puts "📊 Response contains #{response.items.length} items"
  end
end
```

### Single Item Testing

```ruby
describe "Your API" do
  it "returns specific item details" do
    puts "\n🔍 Testing Your API..."
    
    response = client.your_specific_item(123)
    
    expect(response).to be_a(MangoApps::Response)
    expect(response).to respond_to(:item)
    puts "✅ Your API call successful!"
    puts "📊 Response contains item details"
  end
end
```

## Response Validation

### Clean Response API

All responses are automatically wrapped in `MangoApps::Response` objects:

```ruby
# Clean dot notation access
response = client.your_endpoint
name = response.item.name
email = response.item.email

# Still supports hash access if needed
name = response[:item][:name]
```

### Testing Response Structure

```ruby
# Test that response has expected structure
expect(response).to be_a(MangoApps::Response)
expect(response).to respond_to(:expected_key)

# Test array responses
expect(response.items).to be_an(Array)
expect(response.items.first).to respond_to(:name)

# Test single item responses
expect(response.item).to respond_to(:name)
expect(response.item).to respond_to(:id)
```

## Common API Patterns

### List Endpoints

```ruby
def list_items(params = {})
  get("v2/items.json", params: params)
end
```

### Get Single Item

```ruby
def get_item(id, params = {})
  get("v2/items/#{id}.json", params: params)
end
```

### Search Endpoints

```ruby
def search_items(query, params = {})
  get("v2/items/search.json", params: params.merge(q: query))
end
```

### Paginated Endpoints

```ruby
def list_items(page: 1, per_page: 20, params: {})
  get("v2/items.json", params: params.merge(page: page, per_page: per_page))
end
```

## Error Handling

### API Errors

```ruby
begin
  response = client.your_endpoint
rescue MangoApps::APIError => e
  puts "API error: #{e.message}"
rescue MangoApps::AuthenticationError => e
  puts "Authentication failed: #{e.message}"
end
```

### Test Error Scenarios

```ruby
describe "Error Handling" do
  it "handles invalid parameters gracefully" do
    expect {
      client.your_endpoint(invalid_param: "test")
    }.not_to raise_error
  end
end
```

## Best Practices

### 1. Real TDD First

- Always write tests before implementation
- No mocking - use actual MangoApps API
- Test against real data and responses

### 2. Clean Response API

- Use `MangoApps::Response` objects
- Test dot notation access
- Validate response structure with `respond_to?`

### 3. Consistent Naming

- Use descriptive method names
- Follow existing patterns
- Use snake_case for method names

### 4. Error Handling

- Handle API errors gracefully
- Provide meaningful error messages
- Test error scenarios

### 5. Documentation

- Add comments for complex logic
- Use descriptive variable names
- Keep methods small and focused

## Testing Commands

### Run All Tests

```bash
# Run all module tests
./run_tests.sh

# Run specific module tests
bundle exec rspec spec/mangoapps/your_module_spec.rb --format documentation

# Run with verbose output
bundle exec rspec spec/mangoapps/ --format documentation
```

### OAuth Token Management

```bash
# Get fresh token (when expired)
./run_auth.sh

# Run tests (requires valid token)
./run_tests.sh
```

## Module Examples

### Users Module

```ruby
# lib/mangoapps/modules/users.rb
module MangoApps
  class Client
    module Users
      def me
        get("v2/users/me.json")
      end
    end
  end
end
```

### Learn Module

```ruby
# lib/mangoapps/modules/learn.rb
module MangoApps
  class Client
    module Learn
      def course_catalog
        get("v2/learn/course_catalog.json")
      end
      
      def course_categories
        get("v2/learn/course_categories.json")
      end
    end
  end
end
```

## Troubleshooting

### Common Issues

1. **Token Expired**: Run `./run_auth.sh` to get fresh token
2. **API Errors**: Check MangoApps API documentation
3. **Response Structure**: Use `puts response.raw_data` to inspect response
4. **Test Failures**: Check that endpoint exists and returns expected data

### Debugging

```ruby
# Inspect raw response data
response = client.your_endpoint
puts response.raw_data

# Check response structure
puts response.class
puts response.methods.grep(/your_expected_method/)
```

## Contributing

1. Follow the real TDD approach
2. Use the module template
3. Test against actual MangoApps API
4. Ensure all tests pass
5. Update documentation

## Resources

- [MangoApps API Documentation](https://www.mangoapps.com/api-documentation/)
- [Ruby Style Guide](https://rubystyle.guide/)
- [RSpec Documentation](https://rspec.info/documentation/)
- [Faraday HTTP Client](https://lostisland.github.io/faraday/)

---

Remember: This SDK uses **real TDD** - no mocking, only actual OAuth testing with clean response validation!
