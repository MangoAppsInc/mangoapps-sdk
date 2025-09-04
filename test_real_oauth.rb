#!/usr/bin/env ruby
# frozen_string_literal: true

# Test script for real OAuth flow with actual authorization code
require_relative "lib/mangoapps"
require "dotenv"
require "securerandom"
require "digest"
require "base64"

Dotenv.load

puts "🚀 MangoApps SDK - Real OAuth Test"
puts "=" * 50

# Create configuration from environment variables
config = MangoApps::Config.new
client = MangoApps::Client.new(config)

puts "✅ Configuration loaded from .env"
puts "   Domain: #{config.domain}"
puts "   Client ID: #{config.client_id[0..15]}..."
puts "   Redirect URI: #{config.redirect_uri}"

# Generate authorization URL with PKCE
code_verifier = Base64.urlsafe_encode64(SecureRandom.random_bytes(32), padding: false)
code_challenge = Base64.urlsafe_encode64(
  Digest::SHA256.digest(code_verifier),
  padding: false
)
state = SecureRandom.hex(16)

auth_url = client.authorization_url(
  state: state,
  code_challenge: code_challenge,
  code_challenge_method: "S256"
)

puts "\n🌐 Authorization URL:"
puts auth_url
puts "\n📋 Instructions:"
puts "1. Open the URL above in your browser"
puts "2. Log in to your MangoApps account"
puts "3. Authorize the application"
puts "4. Copy the 'code' parameter from the redirect URL"
puts "5. Run: ruby test_real_oauth.rb <authorization_code>"

# If authorization code is provided, test the full flow
if ARGV[0]
  authorization_code = ARGV[0]
  puts "\n🔄 Testing token exchange with real authorization code..."

  begin
    client.authenticate!(
      authorization_code: authorization_code,
      code_verifier: code_verifier
    )

    puts "✅ Token exchange successful!"
    puts "   Access Token: #{client.access_token.token[0..30]}..."
    puts "   Expires At: #{client.access_token.expires_at}"
    puts "   Token Type: #{client.access_token.token_type}"

    if client.access_token.refresh_token
      puts "   Refresh Token: #{client.access_token.refresh_token[0..20]}..."
    end

    # Test API call
    puts "\n📡 Testing API call..."
    begin
      posts = client.posts_list(limit: 5)
      puts "✅ API call successful!"
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
  rescue StandardError => e
    puts "❌ Token exchange failed: #{e.message}"
    puts "   Make sure you copied the correct authorization code"
  end
end

puts "\n🎉 Real OAuth test completed!"
