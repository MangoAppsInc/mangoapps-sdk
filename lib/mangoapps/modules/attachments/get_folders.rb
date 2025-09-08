# frozen_string_literal: true

module MangoApps
  class Client
    module Attachments
      module GetFolders
        def get_folders(params = {})
          get("folders.json", params: params)
        end
      end
    end
  end
end
