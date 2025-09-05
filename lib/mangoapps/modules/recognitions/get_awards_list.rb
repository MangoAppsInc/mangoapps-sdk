# frozen_string_literal: true

module MangoApps
  class Client
    module Recognitions
      module GetAwardsList
        def get_awards_list(params = {})
          get("v2/recognitions/get_awards_list.json", params: params)
        end
      end
    end
  end
end
