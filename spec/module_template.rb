# frozen_string_literal: true

# Template for creating new module specs
# Usage: Copy this file and customize for your new module

require_relative "../real_spec_helper"
require_relative "../shared_test_helpers"

RSpec.describe "MangoApps [MODULE_NAME] Module" do
  include SharedTestHelpers
  let(:config) { MangoApps::Config.new }
  let(:client) { MangoApps::Client.new(config) }

  before do
    # Ensure we have a valid token
    unless config.has_valid_token?
      skip "No valid access token found. Run OAuth tests first."
    end
  end

  # Replace [MODULE_NAME] with your actual module name (e.g., "Files", "Projects", etc.)
  # Replace [ENDPOINT_METHOD] with your actual endpoint method (e.g., "files_list", "projects_list", etc.)
  # Replace [RESPONSE_KEY] with the expected response key (e.g., "files", "projects", etc.)

  describe "[FEATURE_NAME]" do
    it "gets [feature description]" do
      test_api_endpoint(
        "🔍 Testing [MODULE_NAME] API - [Feature Description]...",
        :[ENDPOINT_METHOD],
        "[RESPONSE_KEY]"
      ) do |response|
        # Custom validation for this specific endpoint
        validate_array_response(
          response, 
          "[RESPONSE_KEY]", 
          ["id", "name", "created_at"], # Required fields
          "name" # Display field for sample
        )
      end
    end
  end

  # Add more feature tests as needed
  # describe "Another Feature" do
  #   it "tests another endpoint" do
  #     test_api_endpoint(
  #       "🔍 Testing [MODULE_NAME] API - Another Feature...",
  #       :another_endpoint_method,
  #       "another_response_key"
  #     ) do |response|
  #       # Custom validation for this specific endpoint
  #       validate_array_response(
  #         response, 
  #         "another_response_key", 
  #         ["id", "name"], # Required fields
  #         "name" # Display field for sample
  #       )
  #     end
  #   end
  # end
end
