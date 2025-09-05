# frozen_string_literal: true

module MangoApps
  class Client
    module Recognitions
      module TangoGiftCards
        def tango_gift_cards(params = {})
          get("v2/recognitions/tango_gift_cards.json", params: params)
        end
      end
    end
  end
end
