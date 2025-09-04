#!/bin/bash

# MangoApps SDK OAuth Flow
# Gets fresh OAuth token for API access

set -e  # Exit on any error

echo "🔐 MangoApps SDK OAuth Flow"
echo "=========================="
echo ""
echo "📋 This script will:"
echo "   1. 🔐 Get fresh OAuth token"
echo "   2. 💾 Save token to .env file"
echo ""
echo "💡 Usage:"
echo "   ./run_auth.sh  - Interactive OAuth flow"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# No options needed - always do OAuth flow

# Check if .env file exists
if [ ! -f ".env" ]; then
    print_error ".env file not found!"
    print_status "Please create .env file with your MangoApps credentials"
    exit 1
fi

# Check if bundle is installed
if ! command -v bundle &> /dev/null; then
    print_error "Bundler not found. Please install bundler first."
    exit 1
fi

# Install dependencies
print_status "Installing dependencies..."
bundle install

echo ""
print_status "Starting OAuth flow..."
echo ""

# OAuth Flow
echo "🔐 OAuth Flow"
echo "============="
print_status "Starting fresh OAuth flow..."

# Clear any existing tokens to ensure fresh start
print_status "Clearing any existing tokens..."
ruby -e "
require 'dotenv'
Dotenv.load

if File.exist?('.env')
  env_content = File.read('.env')
  
  # Remove existing token lines
  env_content = env_content.lines.reject { |line| 
    line.start_with?('MANGOAPPS_ACCESS_TOKEN=') || 
    line.start_with?('MANGOAPPS_REFRESH_TOKEN=') ||
    line.start_with?('MANGOAPPS_TOKEN_EXPIRES_AT=')
  }.join
  
  File.write('.env', env_content)
  puts '✅ Cleared existing tokens'
end
"

# Generate fresh authorization URL
print_status "Generating fresh authorization URL..."
AUTH_URL=$(ruby -e "
require './lib/mangoapps'
require 'dotenv'
Dotenv.load

config = MangoApps::Config.new
client = MangoApps::Client.new(config)
state = SecureRandom.hex(16)
auth_url = client.authorization_url(state: state)
puts auth_url
")

echo ""
echo "🌐 Step 1: Get Authorization Code"
echo "Open this URL in your browser:"
echo "$AUTH_URL"
echo ""
echo "After authorizing, copy the 'code' parameter from the redirect URL"
echo "Example: https://localhost:3000/oauth/callback?code=YOUR_CODE&state=..."
echo ""

# Wait for user to enter authorization code
print_status "Waiting for authorization code..."
read -p "📝 Enter your authorization code: " AUTH_CODE

if [ -z "$AUTH_CODE" ]; then
    print_error "No authorization code provided. Exiting."
    exit 1
fi

print_status "Exchanging authorization code for access token..."

# Exchange code for token and save to .env
ruby -e "
require './lib/mangoapps'
require 'dotenv'
require 'net/http'
require 'uri'
require 'json'
Dotenv.load

config = MangoApps::Config.new
authorization_code = '$AUTH_CODE'

# Manual token exchange
uri = URI('https://siddus.mangoapps.com/oauth2/token')
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true

body = {
  grant_type: 'authorization_code',
  code: authorization_code,
  redirect_uri: config.redirect_uri,
  client_id: config.client_id,
  client_secret: config.client_secret
}

request = Net::HTTP::Post.new(uri)
request['Content-Type'] = 'application/x-www-form-urlencoded'
request['Accept'] = 'application/json'
request.body = URI.encode_www_form(body)

response = http.request(request)

if response.code == '200'
  token_data = JSON.parse(response.body)
  access_token = token_data['access_token']
  refresh_token = token_data['refresh_token']
  expires_in = token_data['expires_in']
  
  puts '✅ Token exchange successful!'
  puts \"🔑 Access Token: #{access_token[0..20]}...\"
  puts \"🔄 Refresh Token: #{refresh_token[0..20]}...\"
  puts \"⏰ Expires in: #{expires_in} seconds (#{expires_in / 3600} hours)\"
  
  # Update .env file
  env_content = File.read('.env')
  
  # Remove existing token lines
  env_content = env_content.lines.reject { |line| 
    line.start_with?('MANGOAPPS_ACCESS_TOKEN=') || 
    line.start_with?('MANGOAPPS_REFRESH_TOKEN=') ||
    line.start_with?('MANGOAPPS_TOKEN_EXPIRES_AT=')
  }.join
  
  # Add new token lines
  expires_at = Time.now.to_i + expires_in
  env_content += \"\n# OAuth Tokens (auto-generated)\n\"
  env_content += \"MANGOAPPS_ACCESS_TOKEN=#{access_token}\n\"
  env_content += \"MANGOAPPS_REFRESH_TOKEN=#{refresh_token}\n\"
  env_content += \"MANGOAPPS_TOKEN_EXPIRES_AT=#{expires_at}\n\"
  
  File.write('.env', env_content)
  
  puts '✅ Tokens saved to .env file'
else
  puts '❌ Token exchange failed:'
  puts \"   Status: #{response.code}\"
  puts \"   Response: #{response.body}\"
  exit 1
end
"

if [ $? -eq 0 ]; then
    print_success "OAuth flow completed successfully!"
    echo ""
    print_status "You can now run tests with: ./run_tests.sh"
else
    print_error "OAuth flow failed!"
    exit 1
fi

echo ""
echo "🎉 OAuth setup completed!"
echo "========================"
print_success "Fresh OAuth token saved to .env file"
echo ""
print_status "Next steps:"
echo "  - Run tests: ./run_tests.sh"
echo "  - Token expires in 12 hours"
echo "  - Re-run this script when token expires"