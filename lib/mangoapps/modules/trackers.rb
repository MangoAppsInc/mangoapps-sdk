# frozen_string_literal: true

require_relative "trackers/get_trackers"

module MangoApps
  class Client
    module Trackers
      # Include all trackers sub-modules
      include MangoApps::Client::Trackers::GetTrackers
    end
  end
end
