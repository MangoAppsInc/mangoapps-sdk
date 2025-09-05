#!/bin/bash

# MangoApps SDK Interactive Ruby Shell (IRB)
# Usage: ./run_irb.sh

set -e  # Exit on any error

echo "🚀 MangoApps SDK Interactive Ruby Shell (IRB)"
echo "============================================="
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
bundle install > /dev/null 2>&1

# Check token status
print_status "Checking OAuth token status..."
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

print_success "Valid OAuth token found!"

echo ""
print_success "Ready for interactive API testing!"
echo "=========================================="
echo ""
echo "Initialize client:"
echo "config = MangoApps::Config.new"
echo "client = MangoApps::Client.new(config)"
echo ""
echo "Example API calls:"
echo "client.me                    # Get user profile"
echo "client.course_catalog        # Get courses"
echo "client.award_categories      # Get award categories"
echo "client.core_value_tags       # Get core value tags"
echo "client.leaderboard_info      # Get leaderboard"
echo "client.my_learning           # Get learning progress"
echo ""
echo "=========================================="
echo ""
echo "🔑 Token: Valid"
echo ""

# Start IRB with the setup loaded
ruby -e "
require './lib/mangoapps'
require 'dotenv'
require 'irb'

Dotenv.load

# Start IRB
IRB.start
"
