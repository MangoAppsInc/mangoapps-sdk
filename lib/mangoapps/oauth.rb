# frozen_string_literal: true

require "oauth2"
require "json"
require "net/http"
require "uri"

module MangoApps
  class OAuth
    Discovery = Struct.new(:issuer, :authorization_endpoint, :token_endpoint, :userinfo_endpoint,
                           :end_session_endpoint, :jwks_uri)

    def initialize(config)
      @config = config
    end

    # Discover OIDC endpoints from well-known config
    def discover!
      url = URI.parse("#{@config.base_url}/.well-known/openid-configuration")

      begin
        res = Net::HTTP.get_response(url)
        raise MangoApps::DiscoveryError, "OIDC discovery failed: #{res.code}" unless res.is_a?(Net::HTTPSuccess)

        data = JSON.parse(res.body)
        validate_discovery_data(data)

        @discovery = Discovery.new(
          data["issuer"],
          data["authorization_endpoint"],
          data["token_endpoint"],
          data["userinfo_endpoint"],
          data["end_session_endpoint"],
          data["jwks_uri"]
        )
      rescue JSON::ParserError => e
        raise MangoApps::DiscoveryError, "Invalid JSON response from discovery endpoint: #{e.message}"
      rescue Net::TimeoutError, Net::ConnectionFailed, Timeout::Error => e
        raise MangoApps::DiscoveryError, "Failed to connect to discovery endpoint: #{e.message}"
      end
    end

    def discovery
      @discovery || discover!
    end

    # OAuth2::Client using discovered endpoints
    def client
      @client ||= ::OAuth2::Client.new(
        @config.client_id,
        @config.client_secret,
        site: @config.base_url,
        authorize_url: discovery.authorization_endpoint,
        token_url: discovery.token_endpoint
      )
    end

    # Build an auth URL for browser-based login (PKCE optional)
    def authorization_url(state:, code_challenge: nil, code_challenge_method: "S256", extra_params: {})
      params = {
        redirect_uri: @config.redirect_uri,
        scope: @config.scope,
        state: state,
        response_type: "code",
      }.merge(extra_params)

      if code_challenge
        params[:code_challenge] = code_challenge
        params[:code_challenge_method] = code_challenge_method
      end

      client.auth_code.authorize_url(params)
    end

    # Exchange code for tokens (PKCE verifier optional)
    def get_token(authorization_code:, code_verifier: nil)
      token = client.auth_code.get_token(
        authorization_code,
        redirect_uri: @config.redirect_uri,
        headers: { "Content-Type" => "application/x-www-form-urlencoded" },
        code_verifier: code_verifier
      )
      persist(token)
      token
    rescue OAuth2::Error => e
      raise MangoApps::TokenExchangeError, "Token exchange failed: #{e.message}"
    end

    def refresh!(token)
      raise MangoApps::TokenExpiredError, "No refresh_token available" unless token&.refresh_token

      begin
        new_token = token.refresh!
        persist(new_token)
        new_token
      rescue OAuth2::Error => e
        raise MangoApps::TokenExpiredError, "Token refresh failed: #{e.message}"
      end
    end

    def load_token
      @config.token_store&.load
    end

    private

    def validate_discovery_data(data)
      required_fields = %w[issuer authorization_endpoint token_endpoint]
      missing_fields = required_fields - data.keys

      if missing_fields.any?
        raise MangoApps::DiscoveryError, "Missing required fields in discovery response: #{missing_fields.join(', ')}"
      end
    end

    def persist(token)
      @config.token_store&.save(token.to_hash)
    end
  end
end
