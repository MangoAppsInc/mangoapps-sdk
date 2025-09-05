# frozen_string_literal: true

module MangoApps
  class Client
    module Recognitions
      module GetTeamAwards
        def get_team_awards(params = {})
          get("v2/recognitions/get_team_awards.json", params: params)
        end
      end
    end
  end
end
