# frozen_string_literal: true

# IRB setup for MangoApps SDK testing
# Load this in IRB: load 'irb_setup.rb'

require_relative "lib/mangoapps"
require "dotenv"

# Load environment variables
Dotenv.load

# Initialize client
config = MangoApps::Config.new
client = MangoApps::Client.new(config)

puts "🚀 MangoApps SDK loaded in IRB!"
puts "📊 Domain: #{config.domain}"
puts "🔑 Has valid token: #{config.has_valid_token?}"
puts ""
puts "Available objects:"
puts "  config - MangoApps::Config instance"
puts "  client - MangoApps::Client instance"
puts ""
puts "Quick test examples:"
puts "  client.me"
puts "  client.course_catalog"
puts "  client.course_categories"
puts ""
