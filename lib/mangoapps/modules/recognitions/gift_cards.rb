# frozen_string_literal: true

module MangoApps
  class Client
    module Recognitions
      module GiftCards
        def gift_cards(params = {})
          get("v2/recognitions/gift_cards.json", params: params)
        end
      end
    end
  end
end
