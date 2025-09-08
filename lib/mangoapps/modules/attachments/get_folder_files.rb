# frozen_string_literal: true

module MangoApps
  class Client
    module Attachments
      module GetFolderFiles
        def get_folder_files(folder_id, params = {})
          get("folders/#{folder_id}/files.json", params: params)
        end
      end
    end
  end
end
