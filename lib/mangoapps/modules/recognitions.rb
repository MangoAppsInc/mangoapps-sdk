# frozen_string_literal: true

require_relative "recognitions/award_categories"
require_relative "recognitions/core_value_tags"
require_relative "recognitions/leaderboard_info"
require_relative "recognitions/tango_gift_cards"
require_relative "recognitions/gift_cards"
require_relative "recognitions/get_awards_list"
require_relative "recognitions/get_profile_awards"
require_relative "recognitions/get_team_awards"

module MangoApps
  class Client
    module Recognitions
      # Include all recognitions sub-modules
      include MangoApps::Client::Recognitions::AwardCategories
      include MangoApps::Client::Recognitions::CoreValueTags
      include MangoApps::Client::Recognitions::LeaderboardInfo
      include MangoApps::Client::Recognitions::TangoGiftCards
      include MangoApps::Client::Recognitions::GiftCards
      include MangoApps::Client::Recognitions::GetAwardsList
      include MangoApps::Client::Recognitions::GetProfileAwards
      include MangoApps::Client::Recognitions::GetTeamAwards
    end
  end
end
