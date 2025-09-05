#!/bin/bash

# MangoApps SDK Gem Publisher
# Combines dry run and actual publishing with a flag

set -e  # Exit on any error

# Default to dry run unless --publish flag is provided
DRY_RUN=true
if [[ "$1" == "--publish" ]]; then
    DRY_RUN=false
fi

if [[ "$DRY_RUN" == "true" ]]; then
    echo "🧪 MangoApps SDK Gem Publisher - Dry Run"
    echo "========================================"
else
    echo "🚀 MangoApps SDK Gem Publisher"
    echo "=============================="
fi
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

# Show usage if help requested
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "Usage: $0 [--publish] [--help]"
    echo ""
    echo "Options:"
    echo "  --publish    Actually publish the gem to RubyGems.org"
    echo "  --help, -h   Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0              # Dry run (default)"
    echo "  $0 --publish    # Actually publish the gem"
    echo ""
    exit 0
fi

# Check if we're in the right directory
if [ ! -f "mangoapps-sdk.gemspec" ]; then
    print_error "mangoapps-sdk.gemspec not found!"
    print_status "Please run this script from the project root directory"
    exit 1
fi

# Get current version
CURRENT_VERSION=$(ruby -e "require_relative 'lib/mangoapps/version'; puts MangoApps::VERSION")
print_status "Current version: $CURRENT_VERSION"

# Check if gem is already published
print_status "Checking if version $CURRENT_VERSION is already published..."
if gem list mangoapps-sdk -r | grep -q "mangoapps-sdk ($CURRENT_VERSION)"; then
    print_warning "Version $CURRENT_VERSION is already published on RubyGems.org"
    if [[ "$DRY_RUN" == "false" ]]; then
        read -p "Do you want to continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_status "Publishing cancelled"
            exit 0
        fi
    fi
else
    print_success "Version $CURRENT_VERSION is not yet published"
fi

# Clean up old gem files
print_status "Cleaning up old gem files..."
rm -f *.gem
print_success "Old gem files removed"

# Run tests before publishing
print_status "Running tests to ensure everything works..."
if ./run_tests.sh; then
    print_success "All tests passed!"
else
    print_error "Tests failed! Please fix issues before publishing"
    exit 1
fi

# Build the gem
print_status "Building gem..."
if gem build mangoapps-sdk.gemspec; then
    print_success "Gem built successfully!"
else
    print_error "Failed to build gem"
    exit 1
fi

# Check if gem file was created
GEM_FILE="mangoapps-sdk-${CURRENT_VERSION}.gem"
if [ ! -f "$GEM_FILE" ]; then
    print_error "Gem file $GEM_FILE not found after build"
    exit 1
fi

print_status "Gem file created: $GEM_FILE"
print_status "Gem size: $(ls -lh $GEM_FILE | awk '{print $5}')"

# Show gem contents
print_status "Gem contents:"
gem contents $GEM_FILE | head -20
if [ $(gem contents $GEM_FILE | wc -l) -gt 20 ]; then
    echo "... and $(($(gem contents $GEM_FILE | wc -l) - 20)) more files"
fi

# Check RubyGems authentication
print_status "Checking RubyGems authentication..."
if ! gem whoami > /dev/null 2>&1; then
    if [[ "$DRY_RUN" == "true" ]]; then
        print_warning "Not authenticated with RubyGems.org"
        print_status "You would need to run: gem signin"
    else
        print_error "Not authenticated with RubyGems.org"
        print_status "Please run: gem signin"
        exit 1
    fi
else
    RUBYGEMS_USER=$(gem whoami)
    print_success "Authenticated as: $RUBYGEMS_USER"
fi

# Validate gem
print_status "Validating gem..."
if gem check $GEM_FILE; then
    print_success "Gem validation passed!"
else
    print_error "Gem validation failed!"
    exit 1
fi

# Show what would be published
if [[ "$DRY_RUN" == "true" ]]; then
    echo ""
    print_warning "DRY RUN COMPLETE - No actual publishing performed"
    echo "========================================================"
    print_status "Would publish: mangoapps-sdk v$CURRENT_VERSION"
    print_status "Gem file: $GEM_FILE"
    print_status "Size: $(ls -lh $GEM_FILE | awk '{print $5}')"
    print_status "Files: $(gem contents $GEM_FILE | wc -l) files included"
    
    echo ""
    print_status "To actually publish, run:"
    print_status "  $0 --publish"
    echo ""
    print_status "Or manually:"
    print_status "  gem push $GEM_FILE"
    
    # Keep the gem file for manual testing if desired
    print_status "Gem file kept for manual testing: $GEM_FILE"
    exit 0
fi

# Actual publishing section
echo ""
print_warning "About to publish mangoapps-sdk v$CURRENT_VERSION to RubyGems.org"
print_status "Publisher: $RUBYGEMS_USER"
print_status "Gem file: $GEM_FILE"
echo ""
read -p "Are you sure you want to publish? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_status "Publishing cancelled"
    exit 0
fi

# Publish the gem
print_status "Publishing gem to RubyGems.org..."
if gem push $GEM_FILE; then
    print_success "Gem published successfully!"
else
    print_error "Failed to publish gem"
    exit 1
fi

# Verify publication
print_status "Verifying publication..."
sleep 5  # Wait a moment for RubyGems to process

if gem search mangoapps-sdk -r | grep -q "mangoapps-sdk ($CURRENT_VERSION)"; then
    print_success "Gem is now available on RubyGems.org!"
    print_status "Install with: gem install mangoapps-sdk"
    print_status "View at: https://rubygems.org/gems/mangoapps-sdk"
else
    print_warning "Gem may not be immediately available (RubyGems indexing delay)"
    print_status "Check manually at: https://rubygems.org/gems/mangoapps-sdk"
fi

# Clean up
print_status "Cleaning up..."
rm -f $GEM_FILE
print_success "Temporary files cleaned up"

echo ""
echo "🎉 Publishing Complete!"
echo "======================"
print_success "MangoApps SDK v$CURRENT_VERSION has been published!"
echo ""
print_status "Next steps:"
echo "  1. Update your GitHub repository with the latest changes"
echo "  2. Create a GitHub release with tag v$CURRENT_VERSION"
echo "  3. Update any documentation that references the gem"
echo "  4. Monitor for user feedback and issues"
echo ""
print_status "Gem URL: https://rubygems.org/gems/mangoapps-sdk"
print_status "Install: gem install mangoapps-sdk"