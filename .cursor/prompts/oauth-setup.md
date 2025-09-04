# OAuth2/OIDC Setup - MangoApps SDK

Use this prompt when setting up or debugging OAuth2/OpenID Connect authentication.

## OAuth2 Flow Overview

The MangoApps SDK uses OAuth2 with OpenID Connect discovery for authentication.

### 1. Discovery Endpoint
```ruby
# Automatically discovers OIDC endpoints
oauth = MangoApps::OAuth.new(config)
oauth.discover!

# Available endpoints
discovery = oauth.discovery
puts discovery.authorization_endpoint
puts discovery.token_endpoint
puts discovery.userinfo_endpoint
```

### 2. Authorization URL
```ruby
# Generate authorization URL for browser-based login
auth_url = oauth.authorization_url(
  state: "random_state_string",
  code_challenge: "pkce_challenge",  # Optional for PKCE
  code_challenge_method: "S256"      # Optional for PKCE
)
```

### 3. Token Exchange
```ruby
# Exchange authorization code for tokens
token = oauth.get_token(
  authorization_code: "code_from_callback",
  code_verifier: "pkce_verifier"  # Optional for PKCE
)
```

### 4. Token Refresh
```ruby
# Refresh expired tokens
new_token = oauth.refresh!(token)
```

## Configuration

### Basic Config
```ruby
config = MangoApps::Config.new(
  domain: "yourdomain.mangoapps.com",
  client_id: "your_client_id",
  client_secret: "your_client_secret",
  redirect_uri: "http://localhost:3000/callback"
)
```

### With Token Store
```ruby
# Custom token store for persistence
class FileTokenStore
  def save(token_hash)
    File.write("token.json", token_hash.to_json)
  end

  def load
    return nil unless File.exist?("token.json")
    JSON.parse(File.read("token.json"))
  end
end

config = MangoApps::Config.new(
  domain: "yourdomain.mangoapps.com",
  client_id: "your_client_id",
  client_secret: "your_client_secret",
  redirect_uri: "http://localhost:3000/callback",
  token_store: FileTokenStore.new
)
```

## Testing OAuth

### Stub OIDC Discovery
```ruby
# In your tests
stub_request(:get, "https://yourdomain.mangoapps.com/.well-known/openid-configuration")
  .to_return(
    status: 200,
    body: {
      "issuer" => "https://yourdomain.mangoapps.com",
      "authorization_endpoint" => "https://yourdomain.mangoapps.com/oauth/authorize",
      "token_endpoint" => "https://yourdomain.mangoapps.com/oauth/token",
      "userinfo_endpoint" => "https://yourdomain.mangoapps.com/oauth/userinfo"
    }.to_json,
    headers: { "Content-Type" => "application/json" }
  )
```

### Stub Token Exchange
```ruby
stub_request(:post, "https://yourdomain.mangoapps.com/oauth/token")
  .with(
    body: hash_including({
      "grant_type" => "authorization_code",
      "code" => "test_code",
      "redirect_uri" => "http://localhost:3000/callback"
    })
  )
  .to_return(
    status: 200,
    body: {
      "access_token" => "test_access_token",
      "refresh_token" => "test_refresh_token",
      "token_type" => "Bearer",
      "expires_in" => 3600
    }.to_json,
    headers: { "Content-Type" => "application/json" }
  )
```

## Common Issues

### 1. Discovery Endpoint Not Found
**Error**: `OIDC discovery failed: 404`

**Solution**: Check domain and ensure OIDC is enabled
```ruby
# Test discovery endpoint manually
require 'net/http'
require 'json'

url = URI("https://yourdomain.mangoapps.com/.well-known/openid-configuration")
response = Net::HTTP.get_response(url)
puts response.code
puts response.body
```

### 2. Invalid Client Credentials
**Error**: `invalid_client` in token response

**Solution**: Verify client_id and client_secret
```ruby
# Check config values
puts config.client_id
puts config.client_secret
puts config.redirect_uri
```

### 3. Redirect URI Mismatch
**Error**: `redirect_uri_mismatch`

**Solution**: Ensure redirect_uri matches exactly
```ruby
# Must match exactly what's configured in MangoApps
config.redirect_uri = "http://localhost:3000/callback"  # Exact match required
```

### 4. Token Expired
**Error**: `invalid_grant` or 401 Unauthorized

**Solution**: Refresh the token
```ruby
begin
  # Try to use token
  client.posts_list
rescue MangoApps::Client::Error => e
  if e.message.include?("401")
    # Token expired, refresh it
    new_token = oauth.refresh!(current_token)
    # Retry the request
  end
end
```

## PKCE (Proof Key for Code Exchange)

### Generate PKCE Parameters
```ruby
require 'securerandom'
require 'digest'
require 'base64'

# Generate code verifier
code_verifier = Base64.urlsafe_encode64(SecureRandom.random_bytes(32), padding: false)

# Generate code challenge
code_challenge = Base64.urlsafe_encode64(
  Digest::SHA256.digest(code_verifier),
  padding: false
)

# Use in authorization URL
auth_url = oauth.authorization_url(
  state: SecureRandom.hex(16),
  code_challenge: code_challenge,
  code_challenge_method: "S256"
)

# Use in token exchange
token = oauth.get_token(
  authorization_code: code,
  code_verifier: code_verifier
)
```

## Environment Variables

### Recommended Setup
```bash
# .env file
MANGOAPPS_DOMAIN=yourdomain.mangoapps.com
MANGOAPPS_CLIENT_ID=your_client_id
MANGOAPPS_CLIENT_SECRET=your_client_secret
MANGOAPPS_REDIRECT_URI=http://localhost:3000/callback
```

### Load in Ruby
```ruby
require 'dotenv'
Dotenv.load

config = MangoApps::Config.new(
  domain: ENV['MANGOAPPS_DOMAIN'],
  client_id: ENV['MANGOAPPS_CLIENT_ID'],
  client_secret: ENV['MANGOAPPS_CLIENT_SECRET'],
  redirect_uri: ENV['MANGOAPPS_REDIRECT_URI']
)
```

## Security Best Practices

1. **Never commit secrets** to version control
2. **Use environment variables** for sensitive data
3. **Implement PKCE** for public clients
4. **Store tokens securely** (encrypted, not plain text)
5. **Validate state parameter** to prevent CSRF
6. **Use HTTPS** for all OAuth endpoints
7. **Implement token refresh** before expiration

## Debugging OAuth

### Enable Logging
```ruby
require 'logger'
logger = Logger.new(STDOUT)
config = MangoApps::Config.new(
  domain: "yourdomain.mangoapps.com",
  client_id: "your_client_id",
  client_secret: "your_client_secret",
  redirect_uri: "http://localhost:3000/callback",
  logger: logger
)
```

### Check Token Status
```ruby
# Test if token is valid
begin
  client.posts_list
  puts "Token is valid"
rescue MangoApps::Client::Error => e
  puts "Token error: #{e.message}"
end
```

### Manual Token Test
```ruby
# Test token with curl
# curl -H "Authorization: Bearer YOUR_TOKEN" \
#      https://yourdomain.mangoapps.com/api/posts
```
