# frozen_string_literal: true

require_relative "../real_spec_helper"

RSpec.describe "MangoApps OAuth Flow" do
  let(:config) { MangoApps::Config.new }
  let(:client) { MangoApps::Client.new(config) }

  describe "OAuth Token Management" do
    it "generates valid authorization URL" do
      state = SecureRandom.hex(16)
      auth_url = client.authorization_url(state: state)

      expect(auth_url).to include("https://siddus.mangoapps.com/oauth2/authorize")
      expect(auth_url).to include("client_id=#{config.client_id}")
      expect(auth_url).to include("redirect_uri=#{CGI.escape(config.redirect_uri)}")
      expect(auth_url).to include("state=#{state}")
      expect(auth_url).to include("response_type=code")
    end

    it "exchanges authorization code for access token" do
      # Skip this test - it's handled by the shell script
      skip "OAuth token exchange is handled by run_tests.sh script"
    end

    it "validates stored token from .env" do
      # Reload .env to get the token we just saved
      Dotenv.load
      
      config_with_token = MangoApps::Config.new
      
      if config_with_token.has_valid_token?
        puts "✅ Found valid access token in .env"
        puts "🔑 Token: #{config_with_token.access_token[0..20]}..."
        expect(config_with_token.access_token).not_to be_nil
        expect(config_with_token.refresh_token).not_to be_nil
      else
        skip "No valid token found in .env - run OAuth test first"
      end
    end
  end
end
