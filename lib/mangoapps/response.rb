# frozen_string_literal: true

module MangoApps
  # Response wrapper that provides clean dot notation access to MangoApps API responses
  # Abstracts away the ms_response wrapper and provides intuitive access patterns
  class Response
    include Enumerable

    def initialize(data)
      @data = data
      @ms_response = data["ms_response"] || data
    end

    # Delegate to ms_response for cleaner access
    def method_missing(method_name, *args, &block)
      if @ms_response.respond_to?(method_name)
        @ms_response.public_send(method_name, *args, &block)
      elsif @ms_response.is_a?(Hash) && @ms_response.key?(method_name.to_s)
        value = @ms_response[method_name.to_s]
        wrap_value(value)
      elsif @ms_response.is_a?(Hash) && @ms_response.key?(method_name.to_sym)
        value = @ms_response[method_name.to_sym]
        wrap_value(value)
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      @ms_response.respond_to?(method_name, include_private) ||
        (@ms_response.is_a?(Hash) && 
         (@ms_response.key?(method_name.to_s) || @ms_response.key?(method_name.to_sym))) ||
        super
    end

    # Array access for hash-like behavior
    def [](key)
      value = @ms_response[key]
      wrap_value(value)
    end

    # Hash-like key access
    def key?(key)
      @ms_response.key?(key)
    end

    def keys
      @ms_response.keys
    end

    def values
      @ms_response.values.map { |v| wrap_value(v) }
    end

    # Enumerable support
    def each(&block)
      @ms_response.each(&block)
    end

    # Convert back to hash if needed
    def to_h
      @ms_response
    end

    def to_hash
      @ms_response
    end

    # Pretty inspection
    def inspect
      "#<MangoApps::Response:#{object_id} @data=#{@ms_response.inspect}>"
    end

    # Access to raw data if needed
    def raw_data
      @data
    end

    private

    def wrap_value(value)
      case value
      when Hash
        Response.new(value)
      when Array
        value.map { |item| wrap_value(item) }
      else
        value
      end
    end
  end
end
