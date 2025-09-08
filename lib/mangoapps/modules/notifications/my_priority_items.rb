# frozen_string_literal: true

module MangoApps
  class Client
    module Notifications
      module MyPriorityItems
        def my_priority_items(params = {})
          get("v2/uac.json", params: params)
        end
      end
    end
  end
end
