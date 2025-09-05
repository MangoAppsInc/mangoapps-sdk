# Changelog

All notable changes to the MangoApps Ruby SDK will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.5] - 2024-12-19

### Added
- **Get Team Awards API** in Recognitions Module
  - `client.get_team_awards(project_id: id)` - Get team awards for a specific project/team
  - Access to team award feeds, core value tags, and notification counts
  - Clean dot notation access: `response.feeds`, `response.core_value_tags`, and `response.unread_counts`
  - Comprehensive test coverage with real API validation using All Users team

### Enhanced
- **Test Coverage** - Added comprehensive test for get team awards API (8 total recognitions tests)
- **Documentation** - Updated README with get team awards examples and complete recognition workflow
- **API Completeness** - Recognitions module now includes 8 comprehensive endpoints for complete recognition management

## [0.2.4] - 2024-12-19

### Added
- **Get Awards List API** in Recognitions Module
  - `client.get_awards_list(category_id: id)` - Get awards for a specific category
  - Access to award details including name, description, points, reward points, and attachment URLs
  - Clean dot notation access: `response.get_awards_list` with comprehensive award data
  - Comprehensive test coverage with real API validation using Safety & Quality category

### Enhanced
- **Test Coverage** - Added comprehensive test for get awards list API (6 total recognitions tests)
- **Documentation** - Updated README with get awards list examples and complete recognition workflow
- **API Completeness** - Recognitions module now includes 6 comprehensive endpoints for complete recognition management

## [0.2.3] - 2024-12-19

### Added
- **Gift Cards API** in Recognitions Module
  - `client.gift_cards` - Get available gift cards for recognition rewards
  - Access to gift card brands, descriptions, and availability status
  - Clean dot notation access: `response.cards` with `brand_name`, `brand_key`, `description`, and `enabled` fields
  - Comprehensive test coverage with real API validation

### Enhanced
- **Test Coverage** - Added comprehensive test for gift cards API (5 total recognitions tests)
- **Documentation** - Updated README with gift cards examples and complete recognition management workflow
- **API Completeness** - Recognitions module now includes 5 comprehensive endpoints

## [0.2.2] - 2024-12-19

### Added
- **Tango Gift Cards API** in Recognitions Module
  - `client.tango_gift_cards` - Get tango gift cards information and available points
  - Access to gift card terms and available points for recognition rewards
  - Clean dot notation access: `response.tango_cards.available_points` and `response.tango_cards.terms`
- **Enhanced Test Runner** with module-specific testing
  - `./run_tests.sh [module]` - Run tests for specific modules (learn, users, recognitions)
  - `./run_tests.sh all` - Run all tests (default behavior)
  - `./run_tests.sh help` - Show usage help and available modules
  - Improved error handling and user-friendly output

### Enhanced
- **Test Coverage** - Added comprehensive test for tango gift cards API
- **Documentation** - Updated README with tango gift cards examples and new test runner usage
- **Developer Experience** - Faster development with module-specific testing capabilities

## [0.2.1] - 2024-12-19

### Added
- **Course Details API** in Learn Module
  - `client.course_details(course_id)` - Get detailed course information by course ID
  - Comprehensive course data including description, instructors, fields, and URLs
  - Support for course metadata like certification details and skill requirements

## [0.2.0] - 2024-12-19

### Added
- **Recognitions Module** with comprehensive recognition management APIs
  - `client.award_categories` - Get recognition award categories
  - `client.core_value_tags` - Get core value tags for recognition
  - `client.leaderboard_info` - Get user and team leaderboard information
- **Enhanced Learn Module** with user learning progress tracking
  - `client.my_learning` - Get user's learning progress and course information
- **Improved Response API** with clean dot notation access for all endpoints
- **Robust Error Handling** for APIs that may return empty data (e.g., leaderboard)

### Enhanced
- **Modular Architecture** - Recognitions module uses folder structure like Learn module
- **Comprehensive Testing** - All new APIs tested with real OAuth integration
- **Documentation** - Complete README examples for all recognition features
- **Test Coverage** - 7 comprehensive API tests covering all modules

### Technical Improvements
- **Folder Structure** - Recognitions module organized with sub-modules for scalability
- **Error Resilience** - Tests handle both populated and empty API responses gracefully
- **Clean API Design** - Consistent method naming and response handling across all modules

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
- **Development Documentation** (`MODULES.md`)

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
See [MODULES.md](MODULES.md) for guidelines on adding new modules and APIs.
