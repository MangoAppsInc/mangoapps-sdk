# frozen_string_literal: true

require_relative "feeds/feeds"

module MangoApps
  class Client
    module Feeds
      # Include all feeds sub-modules
      include MangoApps::Client::Feeds::Feeds
    end
  end
end
