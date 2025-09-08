# frozen_string_literal: true

module MangoApps
  class Client
    module Recognitions
      module GetAwardFeeds
        def get_award_feeds(params = {})
          get("v2/recognitions/get_award_feeds.json", params: params)
        end
      end
    end
  end
end
