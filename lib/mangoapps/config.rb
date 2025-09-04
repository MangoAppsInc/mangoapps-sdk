# frozen_string_literal: true

module MangoApps
  class Config
    attr_accessor :domain, :client_id, :client_secret, :redirect_uri, :scope,
                  :token_store, :timeout, :open_timeout, :logger

    def initialize(domain:, client_id:, client_secret:, redirect_uri:, scope: "openid profile offline_access", # rubocop:disable Metrics/ParameterLists
                   token_store: nil, timeout: 30, open_timeout: 10, logger: nil)
      @domain        = domain
      @client_id     = client_id
      @client_secret = client_secret
      @redirect_uri  = redirect_uri
      @scope         = scope
      @token_store   = token_store
      @timeout       = timeout
      @open_timeout  = open_timeout
      @logger        = logger
    end

    def base_url  = "https://#{domain}"
    def api_base  = "#{base_url}/api/"
  end
end
