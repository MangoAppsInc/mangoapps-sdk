#!/usr/bin/env ruby
# frozen_string_literal: true

# Simple Usage Example for MangoApps SDK
# This example shows basic usage after authentication

require_relative "../lib/mangoapps"

# Configuration - loaded from .env file
require "dotenv"
Dotenv.load

config = MangoApps::Config.new

client = MangoApps::Client.new(config)

puts "🚀 MangoApps SDK - Simple Usage Example"
puts "=" * 50

# Generate authorization URL
state = SecureRandom.hex(16)
auth_url = client.authorization_url(state: state)

puts "📋 Authorization URL:"
puts auth_url
puts
puts "📝 To use this SDK:"
puts "1. Open the URL above in your browser"
puts "2. Authorize the application"
puts "3. Copy the 'code' parameter from the redirect URL"
puts "4. Use the code to authenticate:"
puts "   client.authenticate!(authorization_code: 'YOUR_CODE')"
puts "5. Make API calls:"
puts "   posts = client.posts_list"
puts "   client.posts_create(title: 'Hello', content: 'World')"
puts
puts "🔗 For complete OAuth flow example, run:"
puts "   ruby examples/oauth_flow.rb"
