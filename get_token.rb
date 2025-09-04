#!/usr/bin/env ruby
# frozen_string_literal: true

require './lib/mangoapps'
require 'dotenv'
require 'net/http'
require 'uri'
require 'json'
Dotenv.load

puts "🔐 MangoApps OAuth Token Manager"
puts "=" * 40

config = MangoApps::Config.new
oauth = MangoApps::OAuth.new(config)

# Generate fresh authorization URL
state = SecureRandom.hex(16)
auth_url = oauth.authorization_url(state: state)

puts "\n🌐 Step 1: Get Authorization Code"
puts "Open this URL in your browser:"
puts auth_url
puts "\nAfter authorizing, copy the 'code' parameter from the redirect URL"
puts "Example: https://localhost:3000/oauth/callback?code=YOUR_CODE&state=..."

print "\n📝 Enter your authorization code: "
authorization_code = gets.chomp

if authorization_code.empty?
  puts "❌ No authorization code provided. Exiting."
  exit 1
end

puts "\n🔄 Step 2: Exchange Code for Access Token"

# Manual token exchange (we know this works)
uri = URI(oauth.discovery.token_endpoint)
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
  
  puts "✅ Token exchange successful!"
  puts "🔑 Access Token: #{access_token[0..20]}..."
  puts "🔄 Refresh Token: #{refresh_token[0..20]}..."
  puts "⏰ Expires in: #{expires_in} seconds (#{expires_in / 3600} hours)"
  
  # Update .env file
  puts "\n💾 Step 3: Saving tokens to .env file"
  
  env_content = File.read('.env')
  
  # Remove existing token lines
  env_content = env_content.lines.reject { |line| 
    line.start_with?('MANGOAPPS_ACCESS_TOKEN=') || 
    line.start_with?('MANGOAPPS_REFRESH_TOKEN=') ||
    line.start_with?('MANGOAPPS_TOKEN_EXPIRES_AT=')
  }.join
  
  # Add new token lines
  expires_at = Time.now.to_i + expires_in
  env_content += "\n# OAuth Tokens (auto-generated)\n"
  env_content += "MANGOAPPS_ACCESS_TOKEN=#{access_token}\n"
  env_content += "MANGOAPPS_REFRESH_TOKEN=#{refresh_token}\n"
  env_content += "MANGOAPPS_TOKEN_EXPIRES_AT=#{expires_at}\n"
  
  File.write('.env', env_content)
  
  puts "✅ Tokens saved to .env file"
  puts "\n🎯 You can now use the SDK with stored tokens!"
  puts "   The access token will be automatically used for API calls."
  
else
  puts "❌ Token exchange failed:"
  puts "   Status: #{response.code}"
  puts "   Response: #{response.body}"
end
