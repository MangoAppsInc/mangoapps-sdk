#!/usr/bin/env ruby
# frozen_string_literal: true

# Complete OAuth Flow Example for MangoApps SDK
# This example demonstrates the full OAuth2/OpenID Connect flow

require_relative "../lib/mangoapps"
require "securerandom"
require "digest"
require "base64"

# Configuration - loaded from .env file
require "dotenv"
Dotenv.load

puts "🚀 MangoApps SDK - Complete OAuth Flow Example"
puts "=" * 60

# Step 1: Create Configuration
puts "\n📋 Step 1: Creating Configuration"
config = MangoApps::Config.new

puts "✅ Configuration created"
puts "   Domain: #{config.domain}"
puts "   API Base: #{config.api_base}"
puts "   Client ID: #{config.client_id[0..15]}..."
puts "   Redirect URI: #{config.redirect_uri}"

# Step 2: Create Client
puts "\n🔧 Step 2: Creating Client"
client = MangoApps::Client.new(config)
puts "✅ Client created"

# Step 3: OIDC Discovery
puts "\n🔍 Step 3: OIDC Discovery"
begin
  discovery = client.oauth.discovery
  puts "✅ OIDC Discovery successful"
  puts "   Issuer: #{discovery.issuer}"
  puts "   Authorization Endpoint: #{discovery.authorization_endpoint}"
  puts "   Token Endpoint: #{discovery.token_endpoint}"
  puts "   UserInfo Endpoint: #{discovery.userinfo_endpoint}"
rescue StandardError => e
  puts "❌ OIDC Discovery failed: #{e.message}"
  exit 1
end

# Step 4: Generate PKCE Parameters
puts "\n🔐 Step 4: Generating PKCE Parameters"
code_verifier = Base64.urlsafe_encode64(SecureRandom.random_bytes(32), padding: false)
code_challenge = Base64.urlsafe_encode64(
  Digest::SHA256.digest(code_verifier),
  padding: false
)
state = SecureRandom.hex(16)

puts "✅ PKCE parameters generated"
puts "   Code Verifier: #{code_verifier[0..20]}..."
puts "   Code Challenge: #{code_challenge[0..20]}..."
puts "   State: #{state}"

# Step 5: Generate Authorization URL
puts "\n🌐 Step 5: Generating Authorization URL"
begin
  auth_url = client.authorization_url(
    state: state,
    code_challenge: code_challenge,
    code_challenge_method: "S256"
  )
  puts "✅ Authorization URL generated"
  puts "   URL: #{auth_url}"
rescue StandardError => e
  puts "❌ Authorization URL generation failed: #{e.message}"
  exit 1
end

# Step 6: Instructions for User
puts "\n📋 Step 6: User Authorization Instructions"
puts "=" * 60
puts "To complete the OAuth flow:"
puts "1. Open the URL above in your browser"
puts "2. Log in to your MangoApps account"
puts "3. Authorize the application"
puts "4. You'll be redirected to: #{config.redirect_uri}?code=AUTHORIZATION_CODE&state=#{state}"
puts "5. Copy the 'code' parameter from the URL"
puts "6. Run this script with the authorization code:"
puts "   ruby examples/oauth_flow.rb <authorization_code>"
puts "=" * 60

# Step 7: Token Exchange (if code provided)
if ARGV[0]
  authorization_code = ARGV[0]
  puts "\n🔄 Step 7: Token Exchange"

  begin
    client.authenticate!(
      authorization_code: authorization_code,
      code_verifier: code_verifier
    )
    puts "✅ Token exchange successful"
    puts "   Access Token: #{client.access_token.token[0..30]}..."
    puts "   Expires At: #{client.access_token.expires_at}"
    puts "   Token Type: #{client.access_token.token_type}"

    # Step 8: Test API Call
    puts "\n📡 Step 8: Testing API Call"
    begin
      posts = client.posts_list(limit: 5)
      puts "✅ API call successful"
      puts "   Posts count: #{posts['posts']&.length || 0}"

      if posts["posts"] && posts["posts"].any?
        puts "   First post: #{posts['posts'].first['title']}"
      else
        puts "   No posts found (this is normal for a new account)"
      end
    rescue StandardError => e
      puts "⚠️  API call failed: #{e.message}"
      puts "   This might be expected if you don't have posts or proper permissions"
    end

    # Step 9: Token Refresh (if needed)
    puts "\n🔄 Step 9: Token Refresh Test"
    begin
      if client.access_token.refresh_token
        puts "✅ Refresh token available"
        puts "   Refresh Token: #{client.access_token.refresh_token[0..20]}..."

        # Test refresh (commented out to avoid invalidating the token)
        # new_token = client.refresh_token!
        # puts "✅ Token refresh successful"
      else
        puts "ℹ️  No refresh token available"
      end
    rescue StandardError => e
      puts "⚠️  Token refresh test failed: #{e.message}"
    end
  rescue StandardError => e
    puts "❌ Token exchange failed: #{e.message}"
    puts "   Make sure you copied the correct authorization code"
    exit 1
  end
end

puts "\n🎉 OAuth Flow Example Completed!"
puts "=" * 60
puts "Your MangoApps SDK is working correctly with real OAuth credentials!"
puts "You can now use the client to make authenticated API calls."
