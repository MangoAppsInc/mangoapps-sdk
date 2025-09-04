#!/usr/bin/env ruby
# frozen_string_literal: true

# Integration test script for MangoApps SDK
# This script tests the actual OAuth flow with real MangoApps credentials

require "./lib/mangoapps"
require "securerandom"
require "digest"
require "base64"

# Configuration - loaded from .env file
require "dotenv"
Dotenv.load

puts "🚀 MangoApps SDK Integration Test"
puts "=" * 50

# Create configuration
config = MangoApps::Config.new

puts "✅ Configuration created"
puts "   Domain: #{config.domain}"
puts "   Client ID: #{config.client_id[0..10]}..."
puts "   API Base: #{config.api_base}"
puts "   Redirect URI: #{config.redirect_uri}"

# Create client
client = MangoApps::Client.new(config)
puts "✅ Client created"

# Test OIDC Discovery
puts "\n🔍 Testing OIDC Discovery..."
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

# Generate PKCE parameters
puts "\n🔐 Generating PKCE parameters..."
code_verifier = Base64.urlsafe_encode64(SecureRandom.random_bytes(32), padding: false)
code_challenge = Base64.urlsafe_encode64(
  Digest::SHA256.digest(code_verifier),
  padding: false
)
state = SecureRandom.hex(16)

puts "✅ PKCE parameters generated"
puts "   Code Verifier: #{code_verifier[0..10]}..."
puts "   Code Challenge: #{code_challenge[0..10]}..."
puts "   State: #{state}"

# Generate authorization URL
puts "\n🌐 Generating authorization URL..."
begin
  auth_url = client.authorization_url(
    state: state,
    code_challenge: code_challenge,
    code_challenge_method: "S256"
  )
  puts "✅ Authorization URL generated"
  puts "   URL: #{auth_url}"
  puts "\n📋 Next steps:"
  puts "   1. Open the URL above in your browser"
  puts "   2. Authorize the application"
  puts "   3. Copy the 'code' parameter from the redirect URL"
  puts "   4. Run: ruby test_integration.rb <authorization_code>"
rescue StandardError => e
  puts "❌ Authorization URL generation failed: #{e.message}"
  exit 1
end

# If authorization code is provided, test token exchange
if ARGV[0]
  authorization_code = ARGV[0]
  puts "\n🔄 Testing token exchange..."

  begin
    client.authenticate!(
      authorization_code: authorization_code,
      code_verifier: code_verifier
    )
    puts "✅ Token exchange successful"
    puts "   Access Token: #{client.access_token.token[0..20]}..."
    puts "   Expires At: #{client.access_token.expires_at}"

    # Test API call
    puts "\n📡 Testing API call..."
    begin
      posts = client.posts_list(limit: 5)
      puts "✅ API call successful"
      puts "   Posts count: #{posts['posts']&.length || 0}"
      if posts["posts"] && posts["posts"].any?
        puts "   First post: #{posts['posts'].first['title']}"
      end
    rescue StandardError => e
      puts "❌ API call failed: #{e.message}"
      puts "   This might be expected if you don't have posts or proper permissions"
    end
  rescue StandardError => e
    puts "❌ Token exchange failed: #{e.message}"
    exit 1
  end
end

puts "\n🎉 Integration test completed successfully!"
