# frozen_string_literal: true

module MangoApps
  class Client
    module Users
      def me(params = {})
        get("v2/me.json", params: params)
      end
    end
  end
end
