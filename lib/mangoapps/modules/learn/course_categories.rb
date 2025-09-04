# frozen_string_literal: true

module MangoApps
  class Client
    module Learn
      module CourseCategories
        # Get course categories from MangoApps Learn API
        # GET /api/v2/learn/course_categories.json
        def course_categories(params = {})
          get("v2/learn/course_categories.json", params: params)
        end
      end
    end
  end
end
