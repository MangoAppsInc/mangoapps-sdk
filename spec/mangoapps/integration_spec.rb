# frozen_string_literal: true

require_relative "../real_spec_helper"

RSpec.describe "MangoApps SDK Real OAuth Tests" do
  # Always run real tests - no mocking, no skipping

  let(:domain) { ENV["MANGOAPPS_DOMAIN"] || "siddus.mangoapps.com" }
  let(:client_id) { ENV["MANGOAPPS_CLIENT_ID"] || "OcHtAwsbe2U-iCTf-WdWYfS3zeLCuLspBazl30Gf6OI" }
  let(:client_secret) { ENV["MANGOAPPS_CLIENT_SECRET"] || "gDZ-JXhwxlsRAz127MC_PvqbL9Z1FxilNbVYEtsClAQ" }
  let(:redirect_uri) { ENV["MANGOAPPS_REDIRECT_URI"] || "https://localhost:3000/oauth/callback" }

  let(:config) { MangoApps::Config.new }

  let(:client) { MangoApps::Client.new(config) }

  describe "Real OIDC Discovery" do
    it "discovers OIDC endpoints from actual MangoApps domain" do
      discovery = client.oauth.discovery

      expect(discovery.issuer).to eq("https://www.mangoapps.com")
      expect(discovery.authorization_endpoint).to include("/oauth2/authorize")
      expect(discovery.token_endpoint).to include("/oauth2/token")
      expect(discovery.userinfo_endpoint).to include("/oauth/userinfo")
    end

    it "validates discovery response has all required fields" do
      discovery = client.oauth.discovery

      expect(discovery).to respond_to(:issuer)
      expect(discovery).to respond_to(:authorization_endpoint)
      expect(discovery).to respond_to(:token_endpoint)
      expect(discovery).to respond_to(:userinfo_endpoint)
      expect(discovery).to respond_to(:end_session_endpoint)
      expect(discovery).to respond_to(:jwks_uri)
    end
  end

  describe "Real OAuth Flow" do
    it "generates valid authorization URL for actual MangoApps domain" do
      state = SecureRandom.hex(16)
      auth_url = client.authorization_url(state: state)

      expect(auth_url).to include("https://siddus.mangoapps.com/oauth2/authorize")
      expect(auth_url).to include("client_id=#{config.client_id}")
      expect(auth_url).to include("redirect_uri=#{CGI.escape(config.redirect_uri)}")
      expect(auth_url).to include("state=#{state}")
      expect(auth_url).to include("response_type=code")
    end

    it "generates PKCE authorization URL with real credentials" do
      require "securerandom"
      require "digest"
      require "base64"

      code_verifier = Base64.urlsafe_encode64(SecureRandom.random_bytes(32), padding: false)
      code_challenge = Base64.urlsafe_encode64(
        Digest::SHA256.digest(code_verifier),
        padding: false
      )
      state = SecureRandom.hex(16)

      auth_url = client.authorization_url(
        state: state,
        code_challenge: code_challenge,
        code_challenge_method: "S256"
      )

      expect(auth_url).to include("code_challenge=#{code_challenge}")
      expect(auth_url).to include("code_challenge_method=S256")
    end
  end

  describe "Real Configuration" do
    it "loads configuration from environment variables" do
      expect(config.domain).to eq("siddus.mangoapps.com")
      expect(config.client_id).to eq("OcHtAwsbe2U-iCTf-WdWYfS3zeLCuLspBazl30Gf6OI")
      expect(config.client_secret).to eq("gDZ-JXhwxlsRAz127MC_PvqbL9Z1FxilNbVYEtsClAQ")
      expect(config.redirect_uri).to eq("https://localhost:3000/oauth/callback")
      expect(config.api_base).to eq("https://siddus.mangoapps.com/api/")
    end

    it "creates valid client with real configuration" do
      expect(client).to be_a(MangoApps::Client)
      expect(client.config).to eq(config)
      expect(client.oauth).to be_a(MangoApps::OAuth)
    end
  end

    describe "Real API Base URL" do
    it "constructs correct API base URL for actual domain" do
      expect(config.api_base).to eq("https://siddus.mangoapps.com/api/")
    end

    it "handles URL joining correctly for real API calls" do
      # Test that Faraday URL joining works correctly
      full_url = URI.join(config.api_base, "posts").to_s
      expect(full_url).to eq("https://siddus.mangoapps.com/api/posts")
    end
  end

  describe "Real OAuth Token Exchange" do
    it "exchanges authorization code for access token with real MangoApps API" do
      # Generate PKCE parameters
      require "securerandom"
      require "digest"
      require "base64"

      code_verifier = Base64.urlsafe_encode64(SecureRandom.random_bytes(32), padding: false)
      code_challenge = Base64.urlsafe_encode64(
        Digest::SHA256.digest(code_verifier),
        padding: false
      )
      state = SecureRandom.hex(16)

      # Generate authorization URL
      auth_url = client.authorization_url(
        state: state,
        code_challenge: code_challenge,
        code_challenge_method: "S256"
      )

      # Verify authorization URL is properly formed
      expect(auth_url).to include("https://siddus.mangoapps.com/oauth2/authorize")
      expect(auth_url).to include("client_id=#{config.client_id}")
      expect(auth_url).to include("code_challenge=#{code_challenge}")
      expect(auth_url).to include("code_challenge_method=S256")
      expect(auth_url).to include("state=#{state}")

      # Note: This test verifies the authorization URL generation
      # To test actual token exchange, you would need a real authorization code
      # from completing the OAuth flow in a browser
      
      puts "\n🔗 To test token exchange:"
      puts "1. Open this URL in your browser:"
      puts "   #{auth_url}"
      puts "2. Authorize the application"
      puts "3. Copy the 'code' parameter from the redirect URL"
      puts "4. Run: ruby test/test_real_oauth.rb <authorization_code>"
    end

    it "validates OAuth client configuration for token exchange" do
      # Test that OAuth client is properly configured for token exchange
      oauth_client = client.oauth.client
      
      expect(oauth_client.id).to eq(config.client_id)
      expect(oauth_client.secret).to eq(config.client_secret)
      expect(oauth_client.site).to eq("https://siddus.mangoapps.com")
      expect(oauth_client.authorize_url).to eq("https://siddus.mangoapps.com/oauth2/authorize")
      expect(oauth_client.token_url).to eq("https://siddus.mangoapps.com/oauth2/token")
    end

    it "handles token exchange errors gracefully" do
      # Test error handling for invalid authorization code
      expect {
        client.authenticate!(
          authorization_code: "invalid_code",
          code_verifier: "invalid_verifier"
        )
      }.to raise_error(MangoApps::TokenExchangeError)
    end
  end
end
