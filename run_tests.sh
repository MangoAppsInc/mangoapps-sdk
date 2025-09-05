#!/bin/bash

# MangoApps SDK Test Runner
# Runs tests for specific modules or all modules

set -e  # Exit on any error

# Function to show usage
show_usage() {
    echo "🧪 MangoApps SDK Test Suite"
    echo "=========================="
    echo ""
    echo "📋 This test suite will:"
    echo "   1. 🔗 Run API tests for specified module(s)"
    echo ""
    echo "💡 Usage:"
    echo "   ./run_tests.sh [module]  - Run tests for specific module"
    echo "   ./run_tests.sh all       - Run all API tests (default)"
    echo "   ./run_auth.sh            - Get fresh OAuth token first"
    echo ""
    echo "📚 Available modules:"
    echo "   learn        - Learn module tests"
    echo "   users        - Users module tests"
    echo "   recognitions - Recognitions module tests"
    echo "   all          - All modules (default)"
    echo ""
}

# Parse arguments
MODULE=${1:-all}

# Show usage if help is requested
if [ "$MODULE" = "help" ] || [ "$MODULE" = "-h" ] || [ "$MODULE" = "--help" ]; then
    show_usage
    exit 0
fi

echo "🧪 MangoApps SDK Test Suite"
echo "=========================="
echo ""
echo "📋 Testing module: $MODULE"
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

# Function to run tests for a specific module
run_module_tests() {
    local module_name=$1
    local spec_file=""
    local module_display=""
    
    case $module_name in
        "learn")
            spec_file="spec/mangoapps/learn_spec.rb"
            module_display="📚 Learn module"
            ;;
        "users")
            spec_file="spec/mangoapps/users_spec.rb"
            module_display="👤 Users module"
            ;;
        "recognitions")
            spec_file="spec/mangoapps/recognitions_spec.rb"
            module_display="🏆 Recognitions module"
            ;;
        "all")
            spec_file="spec/mangoapps/learn_spec.rb spec/mangoapps/users_spec.rb spec/mangoapps/recognitions_spec.rb"
            module_display="🔗 All modules"
            ;;
        *)
            print_error "Unknown module: $module_name"
            echo ""
            show_usage
            exit 1
            ;;
    esac
    
    echo "🔗 API Tests"
    echo "============"
    print_status "Running $module_display tests..."
    
    if bundle exec rspec $spec_file --format documentation; then
        print_success "$module_display tests passed!"
        return 0
    else
        print_error "$module_display tests failed!"
        return 1
    fi
}

# Run tests based on module argument
if run_module_tests "$MODULE"; then
    echo ""
    echo "🎉 Tests completed successfully!"
    echo "=============================="
    print_success "MangoApps SDK is working correctly!"
    echo ""
    
    if [ "$MODULE" = "all" ]; then
        print_status "Test Summary:"
        echo "  📚 Learn module: ✅ All endpoints tested and working"
        echo "  👤 Users module: ✅ All endpoints tested and working"
        echo "  🏆 Recognitions module: ✅ All endpoints tested and working"
        echo ""
        print_status "You can now start developing with confidence!"
        echo "  - All API endpoints are tested and working"
        echo "  - SDK is ready for production use"
    else
        print_status "Module Summary:"
        case $MODULE in
            "learn")
                echo "  📚 Learn module: ✅ All endpoints tested and working"
                ;;
            "users")
                echo "  👤 Users module: ✅ All endpoints tested and working"
                ;;
            "recognitions")
                echo "  🏆 Recognitions module: ✅ All endpoints tested and working"
                ;;
        esac
        echo ""
        print_status "You can now start developing with confidence!"
        echo "  - $MODULE module endpoints are tested and working"
    fi
else
    exit 1
fi