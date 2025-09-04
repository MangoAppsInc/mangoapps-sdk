# Add New Resource - Real TDD Workflow

Use this prompt when adding a new API resource to the MangoApps SDK.

## Instructions
1. Replace `[RESOURCE_NAME]` with the actual resource name (e.g., `files`, `users`, `tasks`)
2. Replace `[RESOURCE_TITLE]` with the proper title (e.g., `Files`, `Users`, `Tasks`)
3. Follow the **Real TDD** workflow: Real Test → Implement → Refactor
4. **Production Ready**: Include error handling, input validation, and comprehensive tests
5. **Security**: Validate all inputs and handle authentication properly
6. **Real OAuth**: Use actual MangoApps API with real credentials (no mocking)

## Template

### Step 1: Add Real Test to Integration Spec
Add to `spec/mangoapps/integration_spec.rb`:

```ruby
# Add this describe block to the existing integration spec
describe "Real [RESOURCE_TITLE] API" do
  it "lists [RESOURCE_NAME] from actual MangoApps API" do
    # Test with real OAuth token
    result = client.[RESOURCE_NAME]_list
    expect(result).to be_a(Hash)
    expect(result).to have_key("[RESOURCE_NAME]")
  end

  it "creates [RESOURCE_NAME] via actual MangoApps API" do
    # Test with real OAuth token
    result = client.[RESOURCE_NAME]_create(name: "Test [RESOURCE_TITLE]", description: "Test description")
    expect(result).to be_a(Hash)
    expect(result["id"]).to be_present
  end
end

  describe "#[RESOURCE_NAME]_list" do
    it "GETs /[RESOURCE_NAME] with Authorization header and returns parsed JSON" do
      stub_request(:get, "#{api_base}/[RESOURCE_NAME]")
        .with(
          headers: { "Authorization" => "Bearer testtoken" },
          query: hash_including({ "limit" => "10" })
        )
        .to_return(
          status: 200,
          body:   { "[RESOURCE_NAME]" => [{ "id" => 1, "name" => "Test" }] }.to_json,
          headers: { "Content-Type" => "application/json" }
        )

      res = client.[RESOURCE_NAME]_list(limit: 10)

      expect(stub).to have_been_requested
      expect(res).to include("[RESOURCE_NAME]")
      expect(res["[RESOURCE_NAME]"].first["id"]).to eq(1)
    end

    it "handles API errors gracefully" do
      stub_request(:get, "#{api_base}/[RESOURCE_NAME]")
        .to_return(
          status: 500,
          body:   { "error" => "Internal server error" }.to_json,
          headers: { "Content-Type" => "application/json" }
        )

      expect {
        client.[RESOURCE_NAME]_list
      }.to raise_error(MangoApps::ServerError, "Internal server error")
    end

    it "handles authentication errors" do
      allow(client).to receive(:access_token).and_return(nil)

      expect {
        client.[RESOURCE_NAME]_list
      }.to raise_error(MangoApps::AuthenticationError, "Not authenticated")
    end
  end

  describe "#[RESOURCE_NAME]_create" do
    it "POSTs /[RESOURCE_NAME] JSON body and returns created resource" do
      body = { name: "Test [RESOURCE_TITLE]", description: "Test description" }
      stub = stub_request(:post, "#{api_base}/[RESOURCE_NAME]")
        .with(
          headers: {
            "Authorization" => "Bearer testtoken",
            "Content-Type"  => "application/json"
          },
          body: body.to_json
        )
        .to_return(
          status: 201,
          body:   { "id" => 42, "name" => "Test [RESOURCE_TITLE]" }.to_json,
          headers: { "Content-Type" => "application/json" }
        )

      res = client.[RESOURCE_NAME]_create(name: "Test [RESOURCE_TITLE]", description: "Test description")

      expect(stub).to have_been_requested
      expect(res["id"]).to eq(42)
      expect(res["name"]).to eq("Test [RESOURCE_TITLE]")
    end
  end
end
```

### Step 2: Run Tests (Should Fail)
```bash
bundle exec rspec spec/mangoapps/integration_spec.rb
```

### Step 3: Create Resource Module
Create `lib/mangoapps/resources/[RESOURCE_NAME].rb`:

```ruby
# frozen_string_literal: true
module MangoApps
  class Client
    module [RESOURCE_TITLE]
      # GET /api/[RESOURCE_NAME]
      def [RESOURCE_NAME]_list(params = {})
        get("[RESOURCE_NAME]", params: params)
      end

      # POST /api/[RESOURCE_NAME]
      def [RESOURCE_NAME]_create(name:, **extra)
        body = { name: name }.merge(extra)
        post("[RESOURCE_NAME]", body: body)
      end

      # GET /api/[RESOURCE_NAME]/:id
      def [RESOURCE_NAME]_get(id)
        get("[RESOURCE_NAME]/#{id}")
      end

      # PUT /api/[RESOURCE_NAME]/:id
      def [RESOURCE_NAME]_update(id, **params)
        put("[RESOURCE_NAME]/#{id}", body: params)
      end

      # DELETE /api/[RESOURCE_NAME]/:id
      def [RESOURCE_NAME]_delete(id)
        delete("[RESOURCE_NAME]/#{id}")
      end
    end
  end
end
```

### Step 4: Include in Main Module
Update `lib/mangoapps.rb`:

```ruby
# Add this line
require "mangoapps/resources/[RESOURCE_NAME]"

# Add this line at the bottom
MangoApps::Client.include(MangoApps::Client::[RESOURCE_TITLE])
```

### Step 5: Run Tests (Should Pass)
```bash
bundle exec rspec
```

### Step 6: Add More Methods as Needed
Follow the same pattern for additional methods:
- `[RESOURCE_NAME]_search`
- `[RESOURCE_NAME]_update`
- `[RESOURCE_NAME]_delete`
- etc.

## Example Usage
After implementation, the resource can be used like:

```ruby
client = MangoApps::Client.new(config)

# List resources
files = client.[RESOURCE_NAME]_list(limit: 20)

# Create resource
new_resource = client.[RESOURCE_NAME]_create(
  name: "My [RESOURCE_TITLE]",
  description: "Description here"
)

# Get specific resource
resource = client.[RESOURCE_NAME]_get(123)
```

## Notes
- Always use `get("resource")` not `get("/resource")` for proper URL joining
- Stub `access_token` method in all tests
- Use descriptive test names
- Follow the existing code style
- Add error handling tests
