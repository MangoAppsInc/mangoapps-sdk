# frozen_string_literal: true

require_relative "learn/course_catalog"
require_relative "learn/course_categories"
require_relative "learn/my_learning"

module MangoApps
  class Client
    module Learn
      # Include all learn sub-modules
      include MangoApps::Client::Learn::CourseCatalog
      include MangoApps::Client::Learn::CourseCategories
      include MangoApps::Client::Learn::MyLearning
    end
  end
end
