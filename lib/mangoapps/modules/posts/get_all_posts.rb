# frozen_string_literal: true

module MangoApps
  class Client
    module Posts
      module GetAllPosts
        def get_all_posts(params = {})
          get("posts/get_all_posts.json", params: params)
        end
      end
    end
  end
end
