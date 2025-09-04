# frozen_string_literal: true

require_relative "mangoapps/version"
require_relative "mangoapps/errors"
require_relative "mangoapps/config"
require_relative "mangoapps/oauth"
require_relative "mangoapps/client"
require_relative "mangoapps/resources/posts"

module MangoApps; end

# Mix in the resource
MangoApps::Client.include(MangoApps::Client::Posts)
