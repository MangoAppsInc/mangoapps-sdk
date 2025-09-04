# frozen_string_literal: true

require_relative "mangoapps/version"
require_relative "mangoapps/errors"
require_relative "mangoapps/config"
require_relative "mangoapps/oauth"
require_relative "mangoapps/response"
require_relative "mangoapps/client"
require_relative "mangoapps/modules/learn"
require_relative "mangoapps/modules/users"

module MangoApps; end

# Mix in the resources
MangoApps::Client.include(MangoApps::Client::Learn)
MangoApps::Client.include(MangoApps::Client::Users)
