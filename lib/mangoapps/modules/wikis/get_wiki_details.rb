# frozen_string_literal: true

module MangoApps
  class Client
    module Wikis
      module GetWikiDetails
        def get_wiki_details(wiki_id, params = {})
          get("v2/wikis/#{wiki_id}.json", params: params)
        end
      end
    end
  end
end
