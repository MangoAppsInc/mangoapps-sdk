# Debug Test Failure - MangoApps SDK

Use this prompt when tests are failing and you need help debugging.

## Common Issues & Solutions

### 1. WebMock URL Mismatch
**Error**: `WebMock::NetConnectNotAllowedError: Real HTTP connections are disabled`

**Solution**: Check URL matching in stubs
```ruby
# Wrong - missing /api prefix
stub_request(:get, "https://domain.mangoapps.com/posts")

# Correct - includes /api prefix
stub_request(:get, "https://domain.mangoapps.com/api/posts")
```

### 2. Authorization Header Missing
**Error**: Tests fail with 401 Unauthorized

**Solution**: Ensure access token is stubbed
```ruby
before do
  allow(client).to receive(:access_token)
    .and_return(double(token: "testtoken"))
end
```

### 3. Faraday URL Joining Issues
**Error**: URLs not joining correctly (e.g., `/api/posts` becomes `/posts`)

**Solution**: Ensure API base URL ends with `/`
```ruby
# In config.rb
def api_base = "#{base_url}/api/"  # Note trailing slash
```

### 4. JSON Parsing Errors
**Error**: `JSON::ParserError` or similar

**Solution**: Ensure response body is valid JSON
```ruby
.to_return(
  status: 200,
  body: { "data" => [] }.to_json,  # Use .to_json
  headers: { "Content-Type" => "application/json" }
)
```

### 5. Method Not Found
**Error**: `NoMethodError: undefined method`

**Solution**: Ensure resource module is included
```ruby
# In lib/mangoapps.rb
MangoApps::Client.include(MangoApps::Client::Posts)
```

## Debugging Steps

### Step 1: Check Test Output
```bash
bundle exec rspec --format documentation
```

### Step 2: Run Single Test
```bash
bundle exec rspec spec/mangoapps/resources/posts_spec.rb:25
```

### Step 3: Check WebMock Stubs
Look for:
- URL mismatches
- Header mismatches
- Body mismatches
- Query parameter mismatches

### Step 4: Verify Client Configuration
```ruby
config = MangoApps::Config.new(domain: "test.mangoapps.com", ...)
client = MangoApps::Client.new(config)
puts client.http.url_prefix  # Should be https://test.mangoapps.com/api/
```

### Step 5: Check Resource Module
Ensure:
- Module is properly defined
- Methods are correctly named
- Module is included in Client

## Debugging Commands

### Run Tests with Verbose Output
```bash
bundle exec rspec --format documentation --backtrace
```

### Run Single Test File
```bash
bundle exec rspec spec/mangoapps/resources/posts_spec.rb
```

### Run Single Test
```bash
bundle exec rspec spec/mangoapps/resources/posts_spec.rb:25
```

### Check WebMock Configuration
```bash
bundle exec ruby -e "
require './lib/mangoapps'
require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)
puts 'WebMock configured'
"
```

## Common Patterns

### Stubbing GET Requests
```ruby
stub_request(:get, "https://domain.mangoapps.com/api/resource")
  .with(
    headers: { "Authorization" => "Bearer testtoken" },
    query: { "limit" => "10" }
  )
  .to_return(
    status: 200,
    body: { "data" => [] }.to_json,
    headers: { "Content-Type" => "application/json" }
  )
```

### Stubbing POST Requests
```ruby
stub_request(:post, "https://domain.mangoapps.com/api/resource")
  .with(
    headers: {
      "Authorization" => "Bearer testtoken",
      "Content-Type" => "application/json"
    },
    body: { "name" => "Test" }.to_json
  )
  .to_return(
    status: 201,
    body: { "id" => 1, "name" => "Test" }.to_json,
    headers: { "Content-Type" => "application/json" }
  )
```

### Stubbing Error Responses
```ruby
stub_request(:get, "https://domain.mangoapps.com/api/resource")
  .to_return(
    status: 404,
    body: { "error" => "Not found" }.to_json,
    headers: { "Content-Type" => "application/json" }
  )
```

## When to Ask for Help
- Tests are still failing after following these steps
- WebMock errors persist
- Authorization issues
- URL joining problems
- JSON parsing errors
- Module inclusion issues

## Quick Fixes
1. **URL Issues**: Check trailing slashes in config
2. **Auth Issues**: Ensure access_token is stubbed
3. **JSON Issues**: Use `.to_json` on response bodies
4. **Module Issues**: Check include statements
5. **Stub Issues**: Match exact URLs and headers
