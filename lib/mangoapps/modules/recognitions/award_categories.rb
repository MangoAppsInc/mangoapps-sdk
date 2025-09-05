# frozen_string_literal: true

module MangoApps
  class Client
    module Recognitions
      module AwardCategories
        def award_categories(params = {})
          get("v2/recognitions/get_award_categories.json", params: params)
        end
      end
    end
  end
end
