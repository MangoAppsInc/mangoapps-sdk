# frozen_string_literal: true

module MangoApps
  class Client
    module Libraries
      module GetLibraryCategories
        def get_library_categories(library_id, params = {})
          get("users/libraries/#{library_id}.json", params: params)
        end
      end
    end
  end
end
