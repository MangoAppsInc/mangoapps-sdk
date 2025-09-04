# frozen_string_literal: true

require_relative "learn/course_catalog"
require_relative "learn/course_categories"

module MangoApps
  class Client
    module Learn
      # Include all learn sub-modules
      include MangoApps::Client::Learn::CourseCatalog
      include MangoApps::Client::Learn::CourseCategories
    end
  end
end
