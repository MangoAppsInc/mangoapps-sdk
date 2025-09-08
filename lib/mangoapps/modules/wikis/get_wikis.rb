# frozen_string_literal: true

module MangoApps
  class Client
    module Wikis
      module GetWikis
        def get_wikis(params = {})
          get("v2/wikis.json", params: params)
        end
      end
    end
  end
end
