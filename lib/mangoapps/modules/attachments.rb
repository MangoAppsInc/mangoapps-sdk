# frozen_string_literal: true

require_relative "attachments/get_folders"
require_relative "attachments/get_folder_files"

module MangoApps
  class Client
    module Attachments
      # Include all attachments sub-modules
      include MangoApps::Client::Attachments::GetFolders
      include MangoApps::Client::Attachments::GetFolderFiles
    end
  end
end
