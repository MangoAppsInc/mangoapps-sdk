# frozen_string_literal: true

require_relative "libraries/get_libraries"

module MangoApps
  class Client
    module Libraries
      # Include all libraries sub-modules
      include MangoApps::Client::Libraries::GetLibraries
    end
  end
end
