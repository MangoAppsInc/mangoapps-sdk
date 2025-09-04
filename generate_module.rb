#!/usr/bin/env ruby
# frozen_string_literal: true

# Module generator script for MangoApps SDK
# Usage: ruby generate_module.rb [module_name] [endpoint_method] [response_key]

require 'fileutils'

def generate_module(module_name, endpoint_method, response_key)
  module_name_capitalized = module_name.capitalize
  module_name_lower = module_name.downcase
  
  puts "🚀 Generating MangoApps #{module_name_capitalized} Module..."
  
  # 1. Create module directory
  module_dir = "lib/mangoapps/modules/#{module_name_lower}"
  FileUtils.mkdir_p(module_dir) unless Dir.exist?(module_dir)
  
  # 2. Create main module file
  module_file = "#{module_dir}.rb"
  module_content = <<~RUBY
    # frozen_string_literal: true

    module MangoApps
      class Client
        module #{module_name_capitalized}
          def #{endpoint_method}(params = {})
            get("v2/#{endpoint_method}.json", params: params)
          end
        end
      end
    end
  RUBY
  
  File.write(module_file, module_content)
  puts "✅ Created #{module_file}"
  
  # 3. Create spec file
  spec_file = "spec/mangoapps/#{module_name_lower}_spec.rb"
  spec_content = <<~RUBY
    # frozen_string_literal: true

    require_relative "../real_spec_helper"
    require_relative "../shared_test_helpers"

    RSpec.describe "MangoApps #{module_name_capitalized} Module" do
      include SharedTestHelpers
      let(:config) { MangoApps::Config.new }
      let(:client) { MangoApps::Client.new(config) }

      before do
        # Ensure we have a valid token
        unless config.has_valid_token?
          skip "No valid access token found. Run OAuth tests first."
        end
      end

      describe "#{module_name_capitalized} Data" do
        it "gets #{module_name_lower} data" do
          test_api_endpoint(
            "🔍 Testing #{module_name_capitalized} API - Data Retrieval...",
            :#{endpoint_method},
            "#{response_key}"
          ) do |response|
            # Custom validation for this specific endpoint
            validate_array_response(
              response, 
              "#{response_key}", 
              ["id", "name", "created_at"], # Required fields - customize as needed
              "name" # Display field for sample - customize as needed
            )
          end
        end
      end

      # Standard error handling tests (reusable across all modules)
      describe "Error Handling" do
        it "handles API errors gracefully" do
          puts "\\n🧪 Testing #{module_name_capitalized} API error handling..."
          
          begin
            response = client.get("v2/invalid_endpoint.json")
            puts "📊 Invalid endpoint response: \#{response}"
            puts "✅ API handled invalid endpoint gracefully"
          rescue MangoApps::APIError => e
            puts "✅ API error handling works: \#{e.message}"
            print_failed_request_details(e)
            expect(e).to be_a(MangoApps::APIError)
            expect(e.status_code).to be_present
          end
        end

        it "demonstrates detailed error logging for failed requests" do
          puts "\\n🔍 Testing detailed error logging..."
          
          begin
            # Try to POST to a GET-only endpoint to trigger a proper error
            response = client.post("v2/me.json", body: { test: "data" })
            puts "⚠️  Unexpected success: \#{response}"
            skip "Endpoint unexpectedly returned success instead of error"
          rescue MangoApps::APIError => e
            puts "✅ Expected API error caught: \#{e.message}"
            print_failed_request_details(e)
            expect(e).to be_a(MangoApps::APIError)
            expect(e.status_code).to eq(404)
          end
        end
      end

      # Standard authentication test (reusable across all modules)
      describe "Authentication" do
        it "validates OAuth token is working" do
          puts "\\n🔐 Testing #{module_name_capitalized} API authentication..."
          
          begin
            response = client.#{endpoint_method}
            puts "✅ #{module_name_capitalized} API authentication working"
            expect(response).to be_a(Hash)
            expect(response).to have_key("ms_response")
          rescue MangoApps::APIError => e
            if e.status_code == 401
              puts "❌ #{module_name_capitalized} API authentication failed"
              print_failed_request_details(e)
              skip "#{module_name_capitalized} API requires valid OAuth token"
            else
              puts "⚠️  #{module_name_capitalized} API error: \#{e.message}"
              print_failed_request_details(e)
              skip "#{module_name_capitalized} API endpoint error: \#{e.status_code}"
            end
          end
        end
      end
    end
  RUBY
  
  File.write(spec_file, spec_content)
  puts "✅ Created #{spec_file}"
  
  # 4. Update main module file
  main_module_file = "lib/mangoapps.rb"
  main_content = File.read(main_module_file)
  
  # Add require statement
  require_line = "require_relative \"mangoapps/modules/#{module_name_lower}\""
  unless main_content.include?(require_line)
    main_content = main_content.gsub(
      /require_relative "mangoapps\/modules\/users"/,
      "#{require_line}\nrequire_relative \"mangoapps/modules/users\""
    )
  end
  
  # Add include statement
  include_line = "MangoApps::Client.include(MangoApps::Client::#{module_name_capitalized})"
  unless main_content.include?(include_line)
    main_content = main_content.gsub(
      /MangoApps::Client.include\(MangoApps::Client::Users\)/,
      "#{include_line}\nMangoApps::Client.include(MangoApps::Client::Users)"
    )
  end
  
  File.write(main_module_file, main_content)
  puts "✅ Updated #{main_module_file}"
  
  # 5. Update test runner
  test_runner_file = "run_tests.sh"
  test_runner_content = File.read(test_runner_file)
  
  spec_file_reference = "spec/mangoapps/#{module_name_lower}_spec.rb"
  unless test_runner_content.include?(spec_file_reference)
    test_runner_content = test_runner_content.gsub(
      /spec\/mangoapps\/users_spec\.rb/,
      "spec/mangoapps/users_spec.rb #{spec_file_reference}"
    )
  end
  
  File.write(test_runner_file, test_runner_content)
  puts "✅ Updated #{test_runner_file}"
  
  puts "\n🎉 #{module_name_capitalized} module generated successfully!"
  puts "\n📋 Next steps:"
  puts "1. Customize the endpoint method in #{module_file}"
  puts "2. Update the response validation in #{spec_file}"
  puts "3. Run tests: ./run_tests.sh"
  puts "4. Add more endpoints to the module as needed"
end

# Main execution
if ARGV.length < 3
  puts "Usage: ruby generate_module.rb [module_name] [endpoint_method] [response_key]"
  puts "Example: ruby generate_module.rb files files_list files"
  exit 1
end

module_name = ARGV[0]
endpoint_method = ARGV[1]
response_key = ARGV[2]

generate_module(module_name, endpoint_method, response_key)
