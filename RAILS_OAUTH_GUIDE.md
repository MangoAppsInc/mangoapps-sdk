# Simple Rails OAuth 2.0 with MangoApps SDK

A simple guide to authenticate with MangoApps and use the SDK in your Rails app.

## 1. Add the SDK

```ruby
# Gemfile
gem 'mangoapps-sdk'
```

```bash
bundle install
```

## 2. Add OAuth Fields to User

```ruby
# db/migrate/xxx_add_mangoapps_to_users.rb
class AddMangoappsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :mangoapps_token, :string
  end
end
```

## 3. Simple OAuth Controller

```ruby
# app/controllers/oauth_controller.rb
class OauthController < ApplicationController
  CLIENT_ID = 'your_client_id'
  CLIENT_SECRET = 'your_client_secret'
  DOMAIN = 'your-domain.mangoapps.com'
  REDIRECT_URI = 'https://your-app.com/oauth/callback'

  def authorize
    # Redirect to MangoApps OAuth
    url = "https://#{DOMAIN}/oauth/authorize?" + {
      client_id: CLIENT_ID,
      redirect_uri: REDIRECT_URI,
      response_type: 'code'
    }.to_query
    
    redirect_to url
  end

  def callback
    if params[:code]
      # Exchange code for token
      response = HTTParty.post("https://#{DOMAIN}/oauth/token", {
        body: {
          grant_type: 'authorization_code',
          client_id: CLIENT_ID,
          client_secret: CLIENT_SECRET,
          code: params[:code],
          redirect_uri: REDIRECT_URI
        }
      })
      
      if response.success?
        token_data = JSON.parse(response.body)
        current_user.update!(mangoapps_token: token_data['access_token'])
        redirect_to root_path, notice: 'Connected to MangoApps!'
      else
        redirect_to root_path, alert: 'Failed to connect'
      end
    else
      redirect_to root_path, alert: 'OAuth failed'
    end
  end
end
```

## 4. Add Routes

```ruby
# config/routes.rb
Rails.application.routes.draw do
  get '/oauth/authorize', to: 'oauth#authorize'
  get '/oauth/callback', to: 'oauth#callback'
end
```

## 5. Use the SDK

```ruby
# app/controllers/posts_controller.rb
class PostsController < ApplicationController
  def index
    if current_user.mangoapps_token
      # Create MangoApps client
      config = MangoApps::Config.new(
        domain: 'your-domain.mangoapps.com',
        access_token: current_user.mangoapps_token
      )
      client = MangoApps::Client.new(config)
      
      # Use the SDK
      @posts = client.get_all_posts
      @notifications = client.notifications
      @tasks = client.get_tasks
    end
  end
end
```

## 6. Simple View

```erb
<!-- app/views/posts/index.html.erb -->
<% if current_user.mangoapps_token %>
  <h1>Your MangoApps Data</h1>
  
  <h2>Posts</h2>
  <% @posts.feeds.each do |post| %>
    <p><%= post.body %></p>
  <% end %>
  
  <h2>Notifications</h2>
  <% @notifications.data.each do |notification| %>
    <p><%= notification.title %></p>
  <% end %>
  
  <h2>Tasks</h2>
  <% @tasks.tasks.task.each do |task| %>
    <p><%= task.task_title %></p>
  <% end %>
<% else %>
  <%= link_to "Connect to MangoApps", oauth_authorize_path, class: "btn btn-primary" %>
<% end %>
```

## That's it!

1. User clicks "Connect to MangoApps"
2. Gets redirected to MangoApps OAuth
3. Returns with authorization code
4. Exchange code for access token
5. Store token in user record
6. Use token to create MangoApps client
7. Call SDK methods to get data

Simple and straightforward! 🚀
