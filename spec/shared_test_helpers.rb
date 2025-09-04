# frozen_string_literal: true

module SharedTestHelpers
  # Helper method to test API endpoint with common patterns
  def test_api_endpoint(description, endpoint_method, expected_response_key, validation_block = nil)
    puts "\n#{description}"
    
    response = client.send(endpoint_method)
    
    # Common response validation
    expect(response).to be_a(MangoApps::Response)
    expect(response).to respond_to(expected_response_key.to_sym)
    
    puts "✅ API call successful!"
    puts "📊 Response contains #{expected_response_key} data"
    
    # Custom validation if provided
    if validation_block
      instance_exec(response, &validation_block)
    end
    
    response
  end

  # Helper method to validate array response structure
  def validate_array_response(response, array_key, required_fields, sample_display_key = "name")
    array_data = response.send(array_key.to_sym)
    expect(array_data).to be_an(Array)
    
    if array_data.any?
      sample_item = array_data.first
      required_fields.each do |field|
        expect(sample_item).to respond_to(field.to_sym)
      end
      
      puts "✅ Structure validated"
      puts "📊 Found #{array_data.length} items"
      puts "📋 Sample: #{sample_item.send(sample_display_key.to_sym)} (ID: #{sample_item.id})"
    else
      puts "📊 List is empty"
    end
  end

  # Helper method to validate nested object structure
  def validate_nested_structure(response, path, required_fields)
    current = response
    path.each { |key| current = current.send(key.to_sym) }
    
    required_fields.each do |field|
      expect(current).to respond_to(field.to_sym)
    end
    
    current
  end

  # Helper method to display key information from response
  def display_response_info(response, info_fields)
    info_fields.each do |key, display_name|
      # Support both dot notation and nested access
      if key.include?('.')
        value = response.dig(*key.split('.'))
      else
        value = response.send(key.to_sym) if response.respond_to?(key.to_sym)
      end
      puts "📊 #{display_name}: #{value}" if value
    end
  end
end
