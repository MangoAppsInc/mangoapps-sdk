# frozen_string_literal: true

module MangoApps
  class Client
    module Trackers
      module GetTrackers
        def get_trackers(params = {})
          get("v2/trackers.json", params: params)
        end
      end
    end
  end
end
