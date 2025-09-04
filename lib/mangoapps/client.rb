# frozen_string_literal: true

require "faraday"
require "faraday/retry"
require "multi_json"
require "ostruct"

module MangoApps
  class Client
    attr_reader :config, :http, :oauth

    def initialize(config)
      @config = config
      @oauth = OAuth.new(config)
      @http = build_http_client
    end

    # ---- Authentication ----
    def access_token
      @access_token ||= load_access_token
    end

    def authenticated?
      access_token && !token_expired?
    end

    def authenticate!(authorization_code:, code_verifier: nil)
      @access_token = oauth.get_token(
        authorization_code: authorization_code,
        code_verifier: code_verifier
      )
    end

    def refresh_token!
      raise MangoApps::TokenExpiredError, "No refresh token available" unless access_token&.refresh_token

      @access_token = oauth.refresh!(access_token)
    end

    # ---- HTTP Methods ----
    def get(path, params: {}, headers: {})
      request(:get, path, params: params, headers: headers)
    end

    def post(path, body: nil, headers: {})
      request(:post, path, body: body, headers: headers)
    end

    def put(path, body: nil, headers: {})
      request(:put, path, body: body, headers: headers)
    end

    def delete(path, headers: {})
      request(:delete, path, headers: headers)
    end

    # ---- OAuth Helpers ----
    def authorization_url(state:, code_challenge: nil, code_challenge_method: "S256", **extra_params)
      oauth.authorization_url(
        state: state,
        code_challenge: code_challenge,
        code_challenge_method: code_challenge_method,
        extra_params: extra_params
      )
    end

    private

    def build_http_client
      Faraday.new(url: config.api_base) do |f|
        f.request :retry, retry_options
        f.request :json
        f.response :json, content_type: /\bjson$/
        f.options.timeout = config.timeout
        f.options.open_timeout = config.open_timeout
        f.response :logger, config.logger if config.logger
        f.adapter Faraday.default_adapter
      end
    end

    def retry_options
      {
        max: 3,
        interval: 0.3,
        backoff_factor: 2,
        methods: %i[get post put delete],
        exceptions: [Faraday::TimeoutError, Faraday::ConnectionFailed],
      }
    end

    def request(method, path, params: nil, body: nil, headers: {})
      ensure_authenticated!

      # Store request details for error reporting
      request_details = {
        method: method.to_s.upcase,
        url: "#{config.api_base}#{path}",
        params: params,
        body: body,
        headers: auth_headers.merge(headers)
      }

      response = http.run_request(
        method,
        path,
        (body.nil? ? nil : MultiJson.dump(body)),
        auth_headers.merge(headers)
      ) do |req|
        req.params.update(params) if params
      end

      return response.body if response.success?

      handle_error_response(response, request_details)
    end

    def auth_headers
      { "Authorization" => "Bearer #{access_token.token}" }
    end

    def ensure_authenticated!
      return if authenticated?

      raise MangoApps::AuthenticationError, "Not authenticated. Complete OAuth flow first."
    end

    def load_access_token
      # First try to use stored token from .env
      if config.has_valid_token?
        # Create a simple token object from stored token
        stored_token = OpenStruct.new(
          token: config.access_token,
          refresh_token: config.refresh_token,
          expires_at: ENV["MANGOAPPS_TOKEN_EXPIRES_AT"]&.to_i
        )
        return stored_token
      end
      
      # Fallback to oauth token store
      oauth.load_token
    end

    def token_expired?
      return true unless access_token

      # Check if token expires within the next 5 minutes
      if access_token.expires_at
        expires_at = access_token.expires_at.is_a?(Integer) ? Time.at(access_token.expires_at) : access_token.expires_at
        expires_at < (Time.now + 300)
      else
        false
      end
    end

    def handle_error_response(response, request_details = nil)
      error_class = case response.status
                    when 400 then MangoApps::BadRequestError
                    when 401 then MangoApps::UnauthorizedError
                    when 403 then MangoApps::ForbiddenError
                    when 404 then MangoApps::NotFoundError
                    when 429 then MangoApps::RateLimitError
                    when 500..599 then MangoApps::ServerError
                    else MangoApps::APIError
                    end

      error_message = extract_error_message(response)
      raise error_class.new(
        error_message,
        status_code: response.status,
        response_body: response.body,
        request_details: request_details
      )
    end

    def extract_error_message(response)
      if response.body.is_a?(Hash) && response.body["error"]
        response.body["error"]
      elsif response.body.is_a?(Hash) && response.body["message"]
        response.body["message"]
      else
        "MangoApps API error: #{response.status}"
      end
    end
  end
end
