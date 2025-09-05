# frozen_string_literal: true

module MangoApps
  class Client
    module Recognitions
      module GetProfileAwards
        def get_profile_awards(params = {})
          get("v2/recognitions/get_profile_awards.json", params: params)
        end
      end
    end
  end
end
