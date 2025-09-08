# frozen_string_literal: true

module MangoApps
  class Client
    module Feeds
      module Feeds
        def feeds(params = {})
          get("feeds.json", params: params)
        end
      end
    end
  end
end
