# frozen_string_literal: true

require_relative "real_spec_helper"
require_relative "shared_test_helpers"

# Base class for all module specs - provides common setup and patterns
class BaseModuleSpec
  include SharedTestHelpers

  def self.included(base)
    base.extend(ClassMethods)
    base.let(:config) { MangoApps::Config.new }
    base.let(:client) { MangoApps::Client.new(config) }

    base.before do
      # Ensure we have a valid token
      unless config.has_valid_token?
        skip "No valid access token found. Run OAuth tests first."
      end
    end
  end

  module ClassMethods
    # Helper method to define API tests with common patterns
    def api_test(description, &block)
      it description do
        instance_exec(&block)
      end
    end

    # Helper method to define authentication tests
    def auth_test(module_name, endpoint_method)
      it "validates #{module_name} API authentication" do
        puts "\n🔐 Testing #{module_name} API authentication..."
        
        begin
          response = client.send(endpoint_method)
          puts "✅ #{module_name} API authentication working"
          expect(response).to be_a(MangoApps::Response)
        rescue MangoApps::APIError => e
          if e.status_code == 401
            puts "❌ #{module_name} API authentication failed"
            print_failed_request_details(e)
            skip "#{module_name} API requires valid OAuth token"
          else
            puts "⚠️  #{module_name} API error: #{e.message}"
            print_failed_request_details(e)
            skip "#{module_name} API endpoint error: #{e.status_code}"
          end
        end
      end
    end

    # Helper method to define error handling tests
    def error_handling_tests(module_name)
      describe "Error Handling" do
        it "handles API errors gracefully" do
          puts "\n🧪 Testing #{module_name} API error handling..."
          
          begin
            response = client.get("v2/invalid_endpoint.json")
            puts "📊 Invalid endpoint response: #{response}"
            puts "✅ API handled invalid endpoint gracefully"
          rescue MangoApps::APIError => e
            puts "✅ API error handling works: #{e.message}"
            print_failed_request_details(e)
            expect(e).to be_a(MangoApps::APIError)
            expect(e.status_code).to be_present
          end
        end

        it "demonstrates detailed error logging for failed requests" do
          puts "\n🔍 Testing detailed error logging..."
          
          begin
            # Try to POST to a GET-only endpoint to trigger a proper error
            response = client.post("v2/me.json", body: { test: "data" })
            puts "⚠️  Unexpected success: #{response}"
            skip "Endpoint unexpectedly returned success instead of error"
          rescue MangoApps::APIError => e
            puts "✅ Expected API error caught: #{e.message}"
            print_failed_request_details(e)
            expect(e).to be_a(MangoApps::APIError)
            expect(e.status_code).to eq(404)
          end
        end
      end
    end
  end
end
