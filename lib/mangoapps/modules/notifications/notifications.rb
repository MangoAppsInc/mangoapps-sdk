# frozen_string_literal: true

module MangoApps
  class Client
    module Notifications
      module Notifications
        def notifications(params = {})
          get("users/notifications.json", params: params)
        end
      end
    end
  end
end
