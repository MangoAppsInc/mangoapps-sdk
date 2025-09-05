# frozen_string_literal: true

module MangoApps
  class Client
    module Learn
      module CourseDetails
        def course_details(course_id, params = {})
          get("v2/learn/courses/#{course_id}.json", params: params)
        end
      end
    end
  end
end
