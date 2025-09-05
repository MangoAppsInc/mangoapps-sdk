# frozen_string_literal: true

module MangoApps
  class Client
    module Recognitions
      module LeaderboardInfo
        def leaderboard_info(params = {})
          get("v2/recognitions/get_leaderboard_info.json", params: params)
        end
      end
    end
  end
end
