# frozen_string_literal: true

require "mangoapps/version"
require "mangoapps/errors"
require "mangoapps/config"
require "mangoapps/oauth"
require "mangoapps/client"
require "mangoapps/resources/posts"

module MangoApps; end

# Mix in the resource
MangoApps::Client.include(MangoApps::Client::Posts)
