# frozen_string_literal: true

module MangoApps
  class Client
    module Libraries
      module GetLibraryItems
        def get_library_items(library_id, category_id, params = {})
          get("users/libraries/#{library_id}/categories/#{category_id}/library_items/get_library_items.json", params: params)
        end
      end
    end
  end
end
