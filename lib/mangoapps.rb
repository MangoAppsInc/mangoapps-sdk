# frozen_string_literal: true

require_relative "mangoapps/version"
require_relative "mangoapps/errors"
require_relative "mangoapps/config"
require_relative "mangoapps/oauth"
require_relative "mangoapps/response"
require_relative "mangoapps/client"
require_relative "mangoapps/modules/learn"
require_relative "mangoapps/modules/users"
require_relative "mangoapps/modules/recognitions"
require_relative "mangoapps/modules/notifications"
require_relative "mangoapps/modules/feeds"
require_relative "mangoapps/modules/posts"
require_relative "mangoapps/modules/libraries"
require_relative "mangoapps/modules/trackers"
require_relative "mangoapps/modules/attachments"

module MangoApps; end

# Mix in the resources
MangoApps::Client.include(MangoApps::Client::Learn)
MangoApps::Client.include(MangoApps::Client::Users)
MangoApps::Client.include(MangoApps::Client::Recognitions)
MangoApps::Client.include(MangoApps::Client::Notifications)
MangoApps::Client.include(MangoApps::Client::Feeds)
MangoApps::Client.include(MangoApps::Client::Posts)
MangoApps::Client.include(MangoApps::Client::Libraries)
MangoApps::Client.include(MangoApps::Client::Trackers)
MangoApps::Client.include(MangoApps::Client::Attachments)
