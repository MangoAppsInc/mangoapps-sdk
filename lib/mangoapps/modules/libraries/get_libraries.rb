# frozen_string_literal: true

module MangoApps
  class Client
    module Libraries
      module GetLibraries
        def get_libraries(params = {})
          get("users/libraries/get_libraries.json", params: params)
        end
      end
    end
  end
end
