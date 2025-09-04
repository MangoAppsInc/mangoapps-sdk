#!/bin/bash

# MangoApps SDK Test Runner
# Runs all tests in the correct order

set -e  # Exit on any error

echo "🧪 MangoApps SDK Test Suite"
echo "=========================="
echo ""
echo "📋 This test suite will:"
echo "   1. 🔗 Run API tests"
echo ""
echo "💡 Usage:"
echo "   ./run_tests.sh  - Run API tests (requires valid token in .env)"
echo "   ./run_auth.sh   - Get fresh OAuth token first"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we have a valid token
print_status "Checking for valid OAuth token..."
TOKEN_STATUS=$(ruby -e "
require './lib/mangoapps'
require 'dotenv'
Dotenv.load

config = MangoApps::Config.new
if config.has_valid_token?
  puts 'valid'
else
  puts 'invalid'
end
")

if [ "$TOKEN_STATUS" = "invalid" ]; then
    print_error "No valid OAuth token found in .env"
    print_status "Please run ./run_auth.sh first to get a fresh token"
    exit 1
fi

print_success "Valid OAuth token found - proceeding with tests"

# Check if .env file exists
if [ ! -f ".env" ]; then
    print_error ".env file not found!"
    print_status "Please create .env file with your MangoApps credentials"
    exit 1
fi

# Check if bundle is installed
if ! command -v bundle &> /dev/null; then
    print_error "Bundler not found. Please install bundler first."
    exit 1
fi

# Install dependencies
print_status "Installing dependencies..."
bundle install

echo ""
print_status "Starting API tests..."
echo ""

# API Tests
echo "🔗 API Tests"
echo "============"
print_status "Running API tests..."
if bundle exec rspec spec/mangoapps/api_spec.rb --format documentation; then
    print_success "API tests passed!"
    echo ""
    echo "🎉 All tests completed successfully!"
    echo "=================================="
    print_success "MangoApps SDK is working correctly!"
    echo ""
    print_status "Test Summary:"
    echo "  🔗 API tests: ✅ All endpoints tested and working"
    echo ""
    print_status "You can now start developing with confidence!"
    echo "  - All API endpoints are tested and working"
    echo "  - SDK is ready for production use"
else
    print_error "API tests failed!"
    exit 1
fi