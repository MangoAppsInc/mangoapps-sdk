# frozen_string_literal: true

module MangoApps
  # Base error class for all MangoApps SDK errors
  class Error < StandardError; end

  # Configuration related errors
  class ConfigurationError < Error; end

  # Authentication related errors
  class AuthenticationError < Error; end
  class TokenExpiredError < AuthenticationError; end
  class InvalidCredentialsError < AuthenticationError; end

  # OAuth/OIDC related errors
  class OAuthError < Error; end
  class DiscoveryError < OAuthError; end
  class TokenExchangeError < OAuthError; end

  # API related errors
  class APIError < Error
    attr_reader :status_code, :response_body, :request_details

    def initialize(message, status_code: nil, response_body: nil, request_details: nil)
      super(message)
      @status_code = status_code
      @response_body = response_body
      @request_details = request_details
    end
  end

  # HTTP related errors
  class HTTPError < APIError; end
  class BadRequestError < APIError; end
  class UnauthorizedError < APIError; end
  class ForbiddenError < APIError; end
  class NotFoundError < APIError; end
  class RateLimitError < APIError; end
  class ServerError < APIError; end

  # Client related errors
  class ClientError < Error; end
  class TimeoutError < ClientError; end
  class ConnectionError < ClientError; end
end
