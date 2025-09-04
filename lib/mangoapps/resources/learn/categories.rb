# frozen_string_literal: true

module MangoApps
  class Client
    module Learn
      module Categories
        # Get course categories from MangoApps Learn API
        # GET /api/v2/learn/categories.json
        def course_categories(params = {})
          get("v2/learn/categories.json", params: params)
        end

        # Get specific category details
        # GET /api/v2/learn/categories/{id}.json
        def course_category(category_id, params = {})
          get("v2/learn/categories/#{category_id}.json", params: params)
        end
      end
    end
  end
end
