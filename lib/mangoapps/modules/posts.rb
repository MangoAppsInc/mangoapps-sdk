# frozen_string_literal: true

require_relative "posts/get_all_posts"
require_relative "posts/get_post_by_id"

module MangoApps
  class Client
    module Posts
      # Include all posts sub-modules
      include MangoApps::Client::Posts::GetAllPosts
      include MangoApps::Client::Posts::GetPostById
    end
  end
end
