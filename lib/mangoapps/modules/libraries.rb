# frozen_string_literal: true

require_relative "libraries/get_libraries"
require_relative "libraries/get_library_categories"
require_relative "libraries/get_library_items"

module MangoApps
  class Client
    module Libraries
      # Include all libraries sub-modules
      include MangoApps::Client::Libraries::GetLibraries
      include MangoApps::Client::Libraries::GetLibraryCategories
      include MangoApps::Client::Libraries::GetLibraryItems
    end
  end
end
