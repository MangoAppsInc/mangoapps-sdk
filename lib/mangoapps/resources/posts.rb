# frozen_string_literal: true

module MangoApps
  class Client
    module Posts
      # GET /api/posts
      def posts_list(params = {})
        get("posts", params: params)
      end

      # POST /api/posts
      def posts_create(title:, content:, **extra)
        body = { title: title, content: content }.merge(extra)
        post("posts", body: body)
      end
    end
  end
end
