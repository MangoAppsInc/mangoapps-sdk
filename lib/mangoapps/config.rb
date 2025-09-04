# frozen_string_literal: true

require "dotenv"

module MangoApps
  class Config
    attr_accessor :domain, :client_id, :client_secret, :redirect_uri, :scope,
                  :token_store, :timeout, :open_timeout, :logger, :access_token, :refresh_token

    def initialize(domain: nil, client_id: nil, client_secret: nil, redirect_uri: nil, scope: nil, # rubocop:disable Metrics/ParameterLists
                   token_store: nil, timeout: 30, open_timeout: 10, logger: nil)
      # Load environment variables from .env file
      Dotenv.load if File.exist?(".env")

      @domain        = domain || ENV.fetch("MANGOAPPS_DOMAIN", nil)
      @client_id     = client_id || ENV.fetch("MANGOAPPS_CLIENT_ID", nil)
      @client_secret = client_secret || ENV.fetch("MANGOAPPS_CLIENT_SECRET", nil)
      @redirect_uri  = redirect_uri || ENV["MANGOAPPS_REDIRECT_URI"] || "https://localhost:3000/oauth/callback"
      @scope         = scope || ENV["MANGOAPPS_SCOPE"] || "openid profile email"
      @access_token  = ENV["MANGOAPPS_ACCESS_TOKEN"]
      @refresh_token = ENV["MANGOAPPS_REFRESH_TOKEN"]
      @token_store   = token_store
      @timeout       = timeout
      @open_timeout  = open_timeout
      @logger        = logger

      validate_required_fields!
    end

    def base_url  = "https://#{domain}"
    def api_base  = "#{base_url}/api/"
    
    def token_expired?
      return true unless ENV["MANGOAPPS_TOKEN_EXPIRES_AT"]
      Time.now.to_i >= ENV["MANGOAPPS_TOKEN_EXPIRES_AT"].to_i
    end
    
    def has_valid_token?
      @access_token && !token_expired?
    end

    private

    def validate_required_fields!
      missing_fields = []
      missing_fields << "domain" if @domain.nil? || @domain.empty?
      missing_fields << "client_id" if @client_id.nil? || @client_id.empty?
      missing_fields << "client_secret" if @client_secret.nil? || @client_secret.empty?

      if missing_fields.any?
        raise ArgumentError, "Missing required configuration: #{missing_fields.join(', ')}. " \
                             "Set environment variables or pass as parameters."
      end
    end
  end
end
