#!/usr/bin/env ruby
# frozen_string_literal: true

# TDD Workflow Script for MangoApps SDK
# This script helps you follow TDD when adding new resources

require_relative "lib/mangoapps"
require "dotenv"

Dotenv.load

puts "🚀 MangoApps SDK - TDD Workflow"
puts "=" * 50

puts "📋 TDD Workflow for Adding New Resources:"
puts
puts "1. 🔍 RESEARCH: Understand the MangoApps API endpoint"
puts "   - Check MangoApps API documentation"
puts "   - Test the endpoint manually with your OAuth token"
puts
puts "2. ✍️  WRITE TEST: Create a real test first"
puts "   - Add test to spec/mangoapps/integration_spec.rb"
puts "   - Test against actual MangoApps API"
puts "   - Use real OAuth credentials from .env"
puts
puts "3. 🏃 RUN TEST: Make sure it fails"
puts "   bundle exec rspec spec/mangoapps/integration_spec.rb"
puts
puts "4. 🔧 IMPLEMENT: Add minimal code to make test pass"
puts "   - Create resource module in lib/mangoapps/resources/"
puts "   - Include in lib/mangoapps.rb"
puts "   - Implement just enough to pass the test"
puts
puts "5. ✅ VERIFY: Run test again to ensure it passes"
puts "   bundle exec rspec spec/mangoapps/integration_spec.rb"
puts
puts "6. 🔄 REFACTOR: Improve code while keeping tests green"
puts "   - Clean up implementation"
puts "   - Add error handling"
puts "   - Run tests frequently"
puts
puts "📝 Example Test Structure:"
puts <<~EXAMPLE
  describe "Real [Resource] API" do
    it "lists [resource] from actual MangoApps API" do
      # Test with real OAuth token
      result = client.[resource]_list
      expect(result).to be_a(Hash)
      expect(result).to have_key("[resource]")
    end

    it "creates [resource] via actual MangoApps API" do
      # Test with real OAuth token
      result = client.[resource]_create(title: "Test", content: "Test content")
      expect(result).to be_a(Hash)
      expect(result["id"]).to be_present
    end
  end
EXAMPLE

puts
puts "🔑 Current OAuth Configuration:"
config = MangoApps::Config.new
puts "   Domain: #{config.domain}"
puts "   Client ID: #{config.client_id[0..15]}..."
puts "   Redirect URI: #{config.redirect_uri}"

puts
puts "🌐 To get OAuth token for testing:"
puts "   ruby test_real_oauth.rb"
puts
puts "📚 For complete OAuth flow:"
puts "   ruby examples/oauth_flow.rb"
puts
puts "🎯 Ready to start TDD development!"
