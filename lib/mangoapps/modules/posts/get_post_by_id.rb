# frozen_string_literal: true

module MangoApps
  class Client
    module Posts
      module GetPostById
        def get_post_by_id(post_id, params = {})
          get("posts/#{post_id}.json", params: params)
        end
      end
    end
  end
end
