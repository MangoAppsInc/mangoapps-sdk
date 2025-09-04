# frozen_string_literal: true
require "spec_helper"
require "mangoapps"

RSpec.describe "MangoApps::Client::Posts" do
  let(:domain)        { "yourdomain.mangoapps.com" }
  let(:api_base)      { "https://#{domain}/api" }
  let(:config) do
    MangoApps::Config.new(
      domain: domain,
      client_id:     "cid",
      client_secret: "secret",
      redirect_uri:  "http://localhost/cb"
    )
  end
  let(:client) { MangoApps::Client.new(config) }

  before do
    # Stub an access token so Authorization header is present
    allow(client).to receive(:access_token)
      .and_return(double(token: "testtoken", expires_at: Time.now + 3600))
  end

  describe "#posts_list" do
    it "GETs /posts with Authorization header and returns parsed JSON" do
      stub = stub_request(:get, "#{api_base}/posts")
        .with(
          headers: { "Authorization" => "Bearer testtoken" },
          query: hash_including({ "limit" => "10" })
        )
        .to_return(
          status: 200,
          body:   { "posts" => [{ "id" => 1, "title" => "Hello" }] }.to_json,
          headers: { "Content-Type" => "application/json" }
        )

      res = client.posts_list(limit: 10)

      expect(stub).to have_been_requested
      expect(res).to include("posts")
      expect(res["posts"].first["id"]).to eq(1)
    end
  end

  describe "#posts_create" do
    it "POSTs /posts JSON body and returns created resource" do
      body = { title: "Hi", content: "From SDK", pin: true }
      stub = stub_request(:post, "#{api_base}/posts")
        .with(
          headers: {
            "Authorization" => "Bearer testtoken",
            "Content-Type"  => "application/json"
          },
          body: body.to_json
        )
        .to_return(
          status: 201,
          body:   { "id" => 42, "title" => "Hi" }.to_json,
          headers: { "Content-Type" => "application/json" }
        )

      res = client.posts_create(title: "Hi", content: "From SDK", pin: true)

      expect(stub).to have_been_requested
      expect(res["id"]).to eq(42)
      expect(res["title"]).to eq("Hi")
    end
  end
end
