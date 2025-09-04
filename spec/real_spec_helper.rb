# frozen_string_literal: true

# Real TDD test helper - no mocking, only actual OAuth testing
require "dotenv"
require "mangoapps"

# Load environment variables
Dotenv.load

RSpec.configure do |config|
  # Use documentation format for clear output
  config.default_formatter = "doc"

  # Run tests in random order
  config.order = :random

  # Colorize output
  config.color = true

  # Fail fast on first error
  config.fail_fast = 1

  # Filter out backtrace noise
  config.backtrace_exclusion_patterns = [
    /\/lib\/rspec\//,
    /\/lib\/ruby\//,
    /bin\//
  ]
end
