# frozen_string_literal: true

require_relative "recognitions/award_categories"
require_relative "recognitions/core_value_tags"
require_relative "recognitions/leaderboard_info"

module MangoApps
  class Client
    module Recognitions
      # Include all recognitions sub-modules
      include MangoApps::Client::Recognitions::AwardCategories
      include MangoApps::Client::Recognitions::CoreValueTags
      include MangoApps::Client::Recognitions::LeaderboardInfo
    end
  end
end
