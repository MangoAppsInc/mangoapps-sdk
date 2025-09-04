# Changelog

All notable changes to the MangoApps Ruby SDK will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2024-12-19

### Added
- **Initial Release** of MangoApps Ruby SDK
- **OAuth2/OpenID Connect** authentication with automatic token refresh
- **Modular Architecture** for easy API organization and extension
- **Real TDD Testing** with actual MangoApps API integration (no mocking)
- **Comprehensive Error Handling** with detailed request/response logging
- **Environment Variable Configuration** for secure credential management

### Features
- **Users Module**
  - `client.me` - Get current user profile information
  - User authentication validation
  - Detailed error logging for failed requests

- **Learn Module**
  - `client.course_catalog` - Get available courses
  - `client.course_categories` - Get course categories
  - `client.course_category(id)` - Get specific category details

### Development Tools
- **Separated Scripts** for OAuth and testing workflows
  - `./run_auth.sh` - Interactive OAuth token acquisition
  - `./run_tests.sh` - Fast API testing with token validation
- **Module Generator** (`generate_module.rb`) for automated module creation
- **Shared Test Helpers** for consistent testing patterns
- **Development Documentation** (`MODULE_DEVELOPMENT.md`)

### Technical Implementation
- **Faraday HTTP Client** with retry middleware and JSON handling
- **PKCE Support** for secure OAuth2 flows
- **Token Management** with automatic refresh capabilities
- **Structured Error Classes** for different API error scenarios
- **Request/Response Logging** for debugging failed API calls

### Testing
- **Real API Integration Tests** using actual MangoApps endpoints
- **Comprehensive Test Coverage** for all implemented modules
- **Error Scenario Testing** with detailed logging
- **OAuth Flow Testing** with token validation

### Documentation
- **Complete README** with setup instructions and examples
- **API Documentation** with usage examples for each module
- **Development Guidelines** for adding new modules
- **Configuration Examples** for different use cases

### Security
- **Environment Variable** configuration for sensitive data
- **PKCE OAuth2** implementation for public clients
- **Secure Token Storage** and management
- **Input Validation** and sanitization

---

## Development Notes

### Architecture Decisions
- **Modular Design**: Each API area (Users, Learn, etc.) is organized into separate modules
- **Real TDD**: All tests use actual MangoApps API calls for authentic validation
- **Error Handling**: Comprehensive error logging with full request/response details
- **Scalability**: Easy to add new modules using the generator script

### Future Roadmap
- **Files Module**: File upload/download and management
- **Posts Module**: Social posts and announcements
- **Groups Module**: User groups and permissions
- **Projects Module**: Project management features
- **Tasks Module**: Task tracking and management
- **Events Module**: Calendar and event management
- **Documents Module**: Document management
- **Announcements Module**: Company announcements

### Contributing
See [MODULE_DEVELOPMENT.md](MODULE_DEVELOPMENT.md) for guidelines on adding new modules and APIs.
