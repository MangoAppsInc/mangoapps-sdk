# frozen_string_literal: true

require_relative "mangoapps/version"
require_relative "mangoapps/errors"
require_relative "mangoapps/config"
require_relative "mangoapps/oauth"
require_relative "mangoapps/client"
require_relative "mangoapps/resources/posts"
require_relative "mangoapps/resources/learn/course_catalog"

module MangoApps; end

# Mix in the resources
MangoApps::Client.include(MangoApps::Client::Posts)
MangoApps::Client.include(MangoApps::Client::Learn::CourseCatalog)
