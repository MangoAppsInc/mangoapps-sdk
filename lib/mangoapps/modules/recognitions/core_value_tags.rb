# frozen_string_literal: true

module MangoApps
  class Client
    module Recognitions
      module CoreValueTags
        def core_value_tags(params = {})
          get("v2/recognitions/get_core_value_tags.json", params: params)
        end
      end
    end
  end
end
