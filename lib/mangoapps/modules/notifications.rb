# frozen_string_literal: true

require_relative "notifications/my_priority_items"

module MangoApps
  class Client
    module Notifications
      # Include all notifications sub-modules
      include MangoApps::Client::Notifications::MyPriorityItems
    end
  end
end
