# frozen_string_literal: true

require_relative "lib/mangoapps/version"

Gem::Specification.new do |s|
  s.name        = "mangoapps-sdk"
  s.version     = MangoApps::VERSION
  s.summary     = "Ruby SDK for MangoApps APIs with OAuth2/OIDC authentication"
  s.description = "A clean, test-driven Ruby SDK for MangoApps APIs with OAuth2/OpenID Connect support. " \
                  "Provides easy-to-use methods for interacting with MangoApps REST APIs including posts, " \
                  "files, users, and more."
  s.authors     = ["MangoApps Inc."]
  s.email       = ["support@mangoapps.com"]
  s.license     = "MIT"
  s.homepage    = "https://github.com/MangoAppsInc/mangoapps-sdk"
  s.required_ruby_version = ">= 3.0"

  # Files to include in the gem
  s.files = Dir["lib/**/*", "README.md", "LICENSE", "CHANGELOG.md"]
  s.require_paths = ["lib"]

  # Runtime dependencies
  s.add_dependency "addressable", "~> 2.8"
  s.add_dependency "faraday", "~> 2.10"
  s.add_dependency "faraday-retry", "~> 2.2"
  s.add_dependency "multi_json", "~> 1.15"
  s.add_dependency "oauth2", "~> 2.0"

  # Metadata
  s.metadata = {
    "source_code_uri" => "https://github.com/MangoAppsInc/mangoapps-sdk",
    "homepage_uri" => "https://www.mangoapps.com",
    "documentation_uri" => "https://rubydoc.info/gems/mangoapps-sdk",
    "changelog_uri" => "https://github.com/MangoAppsInc/mangoapps-sdk/blob/main/CHANGELOG.md",
    "bug_tracker_uri" => "https://github.com/MangoAppsInc/mangoapps-sdk/issues",
    "rubygems_mfa_required" => "true",
  }
end
