# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial release of MangoApps Ruby SDK
- OAuth2/OpenID Connect authentication with PKCE support
- Posts resource with CRUD operations
- Comprehensive error handling with specific exception types
- Automatic token refresh
- Retry logic with exponential backoff
- Token storage interface for persistence
- Comprehensive test coverage with RSpec and WebMock
- RuboCop configuration for code quality
- Detailed documentation and examples

### Features
- **Authentication**: OAuth2/OpenID Connect flow with automatic discovery
- **Posts API**: List, create, get, update, and delete posts
- **Error Handling**: Specific exception types for different error scenarios
- **Retry Logic**: Automatic retries for transient failures
- **Token Management**: Automatic token refresh and persistence
- **Security**: PKCE support for enhanced security
- **Testing**: Comprehensive test suite with WebMock stubs

### Technical Details
- Ruby >= 3.0 support
- Faraday HTTP client with retry middleware
- OAuth2 gem for authentication
- Multi-JSON for flexible JSON handling
- Addressable for URL handling

## [0.1.0] - 2024-01-XX

### Added
- Initial release
- Basic OAuth2 authentication
- Posts resource implementation
- Core SDK architecture
- Test framework setup
