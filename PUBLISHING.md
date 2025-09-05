# Publishing MangoApps SDK

This document explains how to publish the MangoApps SDK gem to RubyGems.org.

## Prerequisites

1. **RubyGems Account**: Sign up at [rubygems.org](https://rubygems.org)
2. **Authentication**: Run `gem signin` to authenticate with RubyGems
3. **MFA Setup**: Enable Multi-Factor Authentication on your RubyGems account (recommended)

## Publishing Script

### Combined Script with Flags

The `publish_gem.sh` script combines both dry run and actual publishing functionality:

#### Dry Run (Default - Recommended First)

Test the publishing process without actually publishing:

```bash
./publish_gem.sh
# or explicitly
./publish_gem.sh --dry-run
```

#### Actual Publishing

When ready to publish:

```bash
./publish_gem.sh --publish
```

#### Help

Show usage information:

```bash
./publish_gem.sh --help
```

### What the Script Does

**Both modes perform:**
- ✅ Check current version
- ✅ Verify version isn't already published
- ✅ Run all tests
- ✅ Build the gem
- ✅ Validate gem contents
- ✅ Check authentication status

**Dry run additionally:**
- ✅ Show what would be published
- ✅ Keep gem file for manual testing

**Publish mode additionally:**
- ✅ Ask for confirmation
- ✅ Publish to RubyGems.org
- ✅ Verify publication
- ✅ Clean up temporary files

## Manual Publishing

If you prefer to publish manually:

```bash
# 1. Run tests
./run_tests.sh

# 2. Build gem
gem build mangoapps-sdk.gemspec

# 3. Publish
gem push mangoapps-sdk-0.2.0.gem

# 4. Clean up
rm *.gem
```

**Note**: The automated script (`./publish_gem.sh --publish`) handles all these steps with additional safety checks and validations.

## Version Management

### Updating Version

1. Edit `lib/mangoapps/version.rb`:
   ```ruby
   module MangoApps
     VERSION = "0.3.0"  # Update version
   end
   ```

2. Update `CHANGELOG.md` with new features

3. Run publishing script

### Version Guidelines

- **Patch** (0.1.1): Bug fixes, no new features
- **Minor** (0.2.0): New features, backward compatible
- **Major** (1.0.0): Breaking changes

## Post-Publishing

After successful publication:

1. **GitHub Release**: Create a release with the version tag
2. **Documentation**: Update any external documentation
3. **Monitoring**: Watch for user feedback and issues
4. **Testing**: Verify the published gem works correctly

## Troubleshooting

### Authentication Issues
```bash
# Re-authenticate
gem signin

# Check current user
gem whoami
```

### Version Already Exists
```bash
# Check published versions
gem list mangoapps-sdk -r

# Update version in version.rb and try again
```

### Test Failures
```bash
# Run tests manually
./run_tests.sh

# Check OAuth token
./run_auth.sh
```

## Security Notes

- The gemspec includes `rubygems_mfa_required: true` for enhanced security
- Never commit API keys or secrets to the repository
- Use environment variables for sensitive configuration
- The gem includes proper metadata and documentation links

## Links

- **RubyGems**: https://rubygems.org/gems/mangoapps-sdk
- **Install**: `gem install mangoapps-sdk`
- **Documentation**: https://rubydoc.info/gems/mangoapps-sdk
- **GitHub**: https://github.com/MangoAppsInc/mangoapps-sdk
