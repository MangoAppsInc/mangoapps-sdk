# frozen_string_literal: true

module MangoApps
  class Client
    module Learn
      module CourseCatalog
        # Get course catalog from MangoApps Learn API
        # GET /api/v2/learn/course_catalog.json
        def course_catalog(params = {})
          get("v2/learn/course_catalog.json", params: params)
        end
      end
    end
  end
end
