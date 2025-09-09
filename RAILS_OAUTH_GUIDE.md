# Rails OAuth 2.0 Integration with MangoApps SDK

This guide demonstrates how to integrate MangoApps OAuth 2.0 authentication into a Rails application, including complete callback URL handling and session management.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Rails Application Setup](#rails-application-setup)
3. [OAuth 2.0 Flow Implementation](#oauth-20-flow-implementation)
4. [Controller Implementation](#controller-implementation)
5. [Routes Configuration](#routes-configuration)
6. [Session Management](#session-management)
7. [Complete Example](#complete-example)
8. [Security Considerations](#security-considerations)
9. [Testing](#testing)

## Prerequisites

- Ruby on Rails 7.0+
- MangoApps SDK gem
- MangoApps OAuth 2.0 application credentials
- SSL-enabled domain (required for OAuth callbacks)

## Rails Application Setup

### 1. Add MangoApps SDK to Gemfile

```ruby
# Gemfile
gem 'mangoapps-sdk'
gem 'omniauth-oauth2'  # For OAuth 2.0 handling
```

### 2. Install Dependencies

```bash
bundle install
```

### 3. Generate OAuth Controller

```bash
rails generate controller Oauth mangoapps_callback
```

## OAuth 2.0 Flow Implementation

### 1. OAuth Service Class

Create a service class to handle OAuth operations:

```ruby
# app/services/mangoapps_oauth_service.rb
class MangoappsOauthService
  OAUTH_BASE_URL = 'https://your-domain.mangoapps.com'
  CLIENT_ID = 'your_client_id'
  CLIENT_SECRET = 'your_client_secret'
  REDIRECT_URI = 'https://your-rails-app.com/oauth/mangoapps_callback'
  SCOPE = 'read write'

  class << self
    def authorization_url(state = nil)
      params = {
        client_id: CLIENT_ID,
        redirect_uri: REDIRECT_URI,
        response_type: 'code',
        scope: SCOPE,
        state: state || generate_state
      }
      
      "#{OAUTH_BASE_URL}/oauth/authorize?#{params.to_query}"
    end

    def exchange_code_for_token(code)
      response = HTTParty.post("#{OAUTH_BASE_URL}/oauth/token", {
        body: {
          grant_type: 'authorization_code',
          client_id: CLIENT_ID,
          client_secret: CLIENT_SECRET,
          code: code,
          redirect_uri: REDIRECT_URI
        },
        headers: {
          'Content-Type' => 'application/x-www-form-urlencoded'
        }
      })

      if response.success?
        JSON.parse(response.body)
      else
        raise "OAuth token exchange failed: #{response.body}"
      end
    end

    def refresh_token(refresh_token)
      response = HTTParty.post("#{OAUTH_BASE_URL}/oauth/token", {
        body: {
          grant_type: 'refresh_token',
          client_id: CLIENT_ID,
          client_secret: CLIENT_SECRET,
          refresh_token: refresh_token
        },
        headers: {
          'Content-Type' => 'application/x-www-form-urlencoded'
        }
      })

      if response.success?
        JSON.parse(response.body)
      else
        raise "Token refresh failed: #{response.body}"
      end
    end

    def create_mangoapps_client(access_token)
      config = MangoApps::Config.new(
        domain: 'your-domain.mangoapps.com',
        access_token: access_token
      )
      MangoApps::Client.new(config)
    end

    private

    def generate_state
      SecureRandom.hex(32)
    end
  end
end
```

### 2. User Model Enhancement

```ruby
# app/models/user.rb
class User < ApplicationRecord
  # Add these fields to your users table via migration
  # t.string :mangoapps_access_token
  # t.string :mangoapps_refresh_token
  # t.datetime :mangoapps_token_expires_at
  # t.string :mangoapps_user_id

  def mangoapps_client
    return nil unless mangoapps_access_token.present?
    
    # Check if token is expired and refresh if needed
    if token_expired?
      refresh_mangoapps_token
    end
    
    MangoappsOauthService.create_mangoapps_client(mangoapps_access_token)
  end

  def token_expired?
    mangoapps_token_expires_at.present? && 
    mangoapps_token_expires_at <= Time.current
  end

  def refresh_mangoapps_token
    return unless mangoapps_refresh_token.present?

    begin
      token_data = MangoappsOauthService.refresh_token(mangoapps_refresh_token)
      
      update!(
        mangoapps_access_token: token_data['access_token'],
        mangoapps_refresh_token: token_data['refresh_token'],
        mangoapps_token_expires_at: Time.current + token_data['expires_in'].seconds
      )
    rescue => e
      Rails.logger.error "Failed to refresh MangoApps token: #{e.message}"
      # Clear invalid tokens
      update!(
        mangoapps_access_token: nil,
        mangoapps_refresh_token: nil,
        mangoapps_token_expires_at: nil
      )
    end
  end

  def mangoapps_authenticated?
    mangoapps_access_token.present?
  end
end
```

## Controller Implementation

### 1. OAuth Controller

```ruby
# app/controllers/oauth_controller.rb
class OauthController < ApplicationController
  before_action :authenticate_user!, except: [:mangoapps_callback]

  def mangoapps_authorize
    # Store state in session for security
    state = SecureRandom.hex(32)
    session[:oauth_state] = state
    
    # Redirect to MangoApps OAuth authorization
    redirect_to MangoappsOauthService.authorization_url(state)
  end

  def mangoapps_callback
    # Verify state parameter for security
    if params[:state] != session[:oauth_state]
      redirect_to root_path, alert: 'Invalid OAuth state parameter'
      return
    end

    # Clear state from session
    session.delete(:oauth_state)

    if params[:error]
      redirect_to root_path, alert: "OAuth error: #{params[:error_description]}"
      return
    end

    begin
      # Exchange authorization code for access token
      token_data = MangoappsOauthService.exchange_code_for_token(params[:code])
      
      # Get user info from MangoApps
      client = MangoappsOauthService.create_mangoapps_client(token_data['access_token'])
      user_info = client.get_user_profile
      
      # Find or create user
      user = find_or_create_user(user_info, token_data)
      
      # Sign in the user
      sign_in(user)
      
      redirect_to dashboard_path, notice: 'Successfully authenticated with MangoApps!'
      
    rescue => e
      Rails.logger.error "OAuth callback error: #{e.message}"
      redirect_to root_path, alert: 'Authentication failed. Please try again.'
    end
  end

  def mangoapps_disconnect
    current_user.update!(
      mangoapps_access_token: nil,
      mangoapps_refresh_token: nil,
      mangoapps_token_expires_at: nil,
      mangoapps_user_id: nil
    )
    
    redirect_to profile_path, notice: 'Disconnected from MangoApps'
  end

  private

  def find_or_create_user(mangoapps_user_info, token_data)
    # Try to find user by MangoApps user ID first
    user = User.find_by(mangoapps_user_id: mangoapps_user_info.id)
    
    if user
      # Update existing user's MangoApps tokens
      user.update!(
        mangoapps_access_token: token_data['access_token'],
        mangoapps_refresh_token: token_data['refresh_token'],
        mangoapps_token_expires_at: Time.current + token_data['expires_in'].seconds,
        mangoapps_user_id: mangoapps_user_info.id
      )
    else
      # Create new user
      user = User.create!(
        email: mangoapps_user_info.email,
        name: mangoapps_user_info.name,
        mangoapps_access_token: token_data['access_token'],
        mangoapps_refresh_token: token_data['refresh_token'],
        mangoapps_token_expires_at: Time.current + token_data['expires_in'].seconds,
        mangoapps_user_id: mangoapps_user_info.id
      )
    end
    
    user
  end
end
```

### 2. Dashboard Controller

```ruby
# app/controllers/dashboard_controller.rb
class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_mangoapps_authenticated

  def index
    @user_profile = current_user.mangoapps_client.get_user_profile
    @recent_posts = current_user.mangoapps_client.get_all_posts(limit: 5)
    @notifications = current_user.mangoapps_client.notifications(limit: 10)
  end

  def mangoapps_data
    client = current_user.mangoapps_client
    
    case params[:data_type]
    when 'posts'
      @data = client.get_all_posts(params.permit(:filter_by, :limit, :offset))
    when 'notifications'
      @data = client.notifications(params.permit(:limit, :offset))
    when 'tasks'
      @data = client.get_tasks(params.permit(:filter, :page, :limit))
    when 'feeds'
      @data = client.feeds(params.permit(:limit, :offset))
    else
      redirect_to dashboard_path, alert: 'Invalid data type'
      return
    end
    
    render json: @data
  end

  private

  def ensure_mangoapps_authenticated
    unless current_user.mangoapps_authenticated?
      redirect_to oauth_mangoapps_authorize_path, 
                  alert: 'Please authenticate with MangoApps to continue'
    end
  end
end
```

## Routes Configuration

```ruby
# config/routes.rb
Rails.application.routes.draw do
  root 'dashboard#index'
  
  # OAuth routes
  get '/oauth/mangoapps_authorize', to: 'oauth#mangoapps_authorize'
  get '/oauth/mangoapps_callback', to: 'oauth#mangoapps_callback'
  delete '/oauth/mangoapps_disconnect', to: 'oauth#mangoapps_disconnect'
  
  # Dashboard routes
  get '/dashboard', to: 'dashboard#index'
  get '/dashboard/mangoapps_data', to: 'dashboard#mangoapps_data'
  
  # User routes
  get '/profile', to: 'users#show'
  patch '/profile', to: 'users#update'
  
  # Devise routes (if using Devise for authentication)
  devise_for :users
end
```

## Session Management

### 1. Application Controller

```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  # Add this if using Devise
  before_action :authenticate_user!
  
  # Add this if using custom authentication
  # before_action :authenticate_user!
  
  private
  
  def authenticate_user!
    # Your authentication logic here
    # This could be Devise, custom session handling, etc.
  end
end
```

### 2. Session Helper

```ruby
# app/helpers/session_helper.rb
module SessionHelper
  def mangoapps_connected?
    current_user&.mangoapps_authenticated?
  end
  
  def mangoapps_user_info
    return nil unless mangoapps_connected?
    
    @mangoapps_user_info ||= current_user.mangoapps_client.get_user_profile
  end
end
```

## Complete Example

### 1. Dashboard View

```erb
<!-- app/views/dashboard/index.html.erb -->
<div class="dashboard">
  <h1>Dashboard</h1>
  
  <% if mangoapps_connected? %>
    <div class="mangoapps-section">
      <h2>MangoApps Integration</h2>
      
      <div class="user-info">
        <h3>Welcome, <%= mangoapps_user_info.name %>!</h3>
        <p>Email: <%= mangoapps_user_info.email %></p>
      </div>
      
      <div class="actions">
        <%= link_to "View Posts", dashboard_mangoapps_data_path(data_type: 'posts'), 
                    class: 'btn btn-primary', remote: true %>
        <%= link_to "View Notifications", dashboard_mangoapps_data_path(data_type: 'notifications'), 
                    class: 'btn btn-info', remote: true %>
        <%= link_to "View Tasks", dashboard_mangoapps_data_path(data_type: 'tasks'), 
                    class: 'btn btn-warning', remote: true %>
        <%= link_to "Disconnect", oauth_mangoapps_disconnect_path, 
                    method: :delete, class: 'btn btn-danger',
                    confirm: 'Are you sure you want to disconnect from MangoApps?' %>
      </div>
      
      <div id="mangoapps-data" class="mt-4">
        <!-- AJAX-loaded data will appear here -->
      </div>
    </div>
  <% else %>
    <div class="mangoapps-section">
      <h2>Connect to MangoApps</h2>
      <p>Connect your MangoApps account to access your data.</p>
      <%= link_to "Connect with MangoApps", oauth_mangoapps_authorize_path, 
                  class: 'btn btn-primary' %>
    </div>
  <% end %>
</div>

<script>
  // Handle AJAX requests for MangoApps data
  document.addEventListener('DOMContentLoaded', function() {
    const dataContainer = document.getElementById('mangoapps-data');
    
    // Handle AJAX links
    document.querySelectorAll('a[data-remote="true"]').forEach(link => {
      link.addEventListener('click', function(e) {
        e.preventDefault();
        
        fetch(this.href, {
          headers: {
            'Accept': 'application/json',
            'X-Requested-With': 'XMLHttpRequest'
          }
        })
        .then(response => response.json())
        .then(data => {
          dataContainer.innerHTML = '<pre>' + JSON.stringify(data, null, 2) + '</pre>';
        })
        .catch(error => {
          dataContainer.innerHTML = '<p class="text-danger">Error loading data: ' + error.message + '</p>';
        });
      });
    });
  });
</script>
```

### 2. Database Migration

```ruby
# db/migrate/xxx_add_mangoapps_fields_to_users.rb
class AddMangoappsFieldsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :mangoapps_access_token, :string
    add_column :users, :mangoapps_refresh_token, :string
    add_column :users, :mangoapps_token_expires_at, :datetime
    add_column :users, :mangoapps_user_id, :string
    
    add_index :users, :mangoapps_user_id, unique: true
  end
end
```

## Security Considerations

### 1. CSRF Protection

```ruby
# app/controllers/oauth_controller.rb
class OauthController < ApplicationController
  # CSRF protection is automatically enabled
  # State parameter provides additional security
end
```

### 2. Token Security

```ruby
# app/models/user.rb
class User < ApplicationRecord
  # Encrypt sensitive tokens
  encrypts :mangoapps_access_token
  encrypts :mangoapps_refresh_token
end
```

### 3. Rate Limiting

```ruby
# config/initializers/rate_limiting.rb
Rails.application.config.middleware.use Rack::Attack

Rack::Attack.throttle('mangoapps_api', limit: 100, period: 1.minute) do |req|
  if req.path.start_with?('/dashboard/mangoapps_data')
    req.session[:user_id]
  end
end
```

## Testing

### 1. Controller Tests

```ruby
# spec/controllers/oauth_controller_spec.rb
require 'rails_helper'

RSpec.describe OauthController, type: :controller do
  describe 'GET #mangoapps_authorize' do
    it 'redirects to MangoApps authorization URL' do
      get :mangoapps_authorize
      expect(response).to have_http_status(:redirect)
      expect(response.location).to include('oauth/authorize')
    end
  end

  describe 'GET #mangoapps_callback' do
    let(:valid_params) do
      {
        code: 'valid_code',
        state: 'valid_state'
      }
    end

    before do
      session[:oauth_state] = 'valid_state'
    end

    it 'handles successful OAuth callback' do
      # Mock the OAuth service
      allow(MangoappsOauthService).to receive(:exchange_code_for_token)
        .and_return({ 'access_token' => 'token', 'refresh_token' => 'refresh' })
      
      allow(MangoappsOauthService).to receive(:create_mangoapps_client)
        .and_return(double(get_user_profile: double(id: '123', email: 'test@example.com', name: 'Test User')))
      
      get :mangoapps_callback, params: valid_params
      
      expect(response).to have_http_status(:redirect)
      expect(response.location).to include('/dashboard')
    end
  end
end
```

### 2. Service Tests

```ruby
# spec/services/mangoapps_oauth_service_spec.rb
require 'rails_helper'

RSpec.describe MangoappsOauthService do
  describe '.authorization_url' do
    it 'generates correct authorization URL' do
      url = described_class.authorization_url('test_state')
      
      expect(url).to include('oauth/authorize')
      expect(url).to include('client_id=your_client_id')
      expect(url).to include('state=test_state')
    end
  end

  describe '.exchange_code_for_token' do
    it 'exchanges code for token' do
      # Mock HTTParty response
      allow(HTTParty).to receive(:post).and_return(
        double(success?: true, body: '{"access_token": "token"}')
      )
      
      result = described_class.exchange_code_for_token('test_code')
      
      expect(result).to eq({ 'access_token' => 'token' })
    end
  end
end
```

## Deployment Considerations

### 1. Environment Variables

```ruby
# config/application.rb
module YourApp
  class Application < Rails::Application
    # Load environment variables
    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'local_env.yml')
      if File.exists?(env_file)
        YAML.load(File.open(env_file)).each do |key, value|
          ENV[key.to_s] = value
        end
      end
    end
  end
end
```

### 2. Production Configuration

```yaml
# config/local_env.yml (not committed to version control)
MANGOAPPS_CLIENT_ID: 'your_production_client_id'
MANGOAPPS_CLIENT_SECRET: 'your_production_client_secret'
MANGOAPPS_DOMAIN: 'your-production-domain.mangoapps.com'
MANGOAPPS_REDIRECT_URI: 'https://your-production-app.com/oauth/mangoapps_callback'
```

## Conclusion

This guide provides a complete OAuth 2.0 integration for Rails applications with MangoApps. The implementation includes:

- ✅ Secure OAuth 2.0 flow with state parameter
- ✅ Token management with automatic refresh
- ✅ Session handling and user management
- ✅ Error handling and security considerations
- ✅ Testing examples
- ✅ Production deployment considerations

The integration allows users to authenticate with MangoApps and access their data through your Rails application while maintaining security best practices.
