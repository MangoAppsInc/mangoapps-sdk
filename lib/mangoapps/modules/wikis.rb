# frozen_string_literal: true

require_relative "wikis/get_wikis"
require_relative "wikis/get_wiki_details"

module MangoApps
  class Client
    module Wikis
      # Include all wikis sub-modules
      include MangoApps::Client::Wikis::GetWikis
      include MangoApps::Client::Wikis::GetWikiDetails
    end
  end
end
