# frozen_string_literal: true

require_relative "notifications/my_priority_items"
require_relative "notifications/notifications"

module MangoApps
  class Client
    module Notifications
      # Include all notifications sub-modules
      include MangoApps::Client::Notifications::MyPriorityItems
      include MangoApps::Client::Notifications::Notifications
    end
  end
end
