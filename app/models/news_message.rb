class NewsMessage < ActiveRecord::Base
  belongs_to :game
  # Get all news for a given round
  def self.round_news(round)
    NewsMessage.where(round: round)
  end

  def created_at
    super.in_time_zone(self.game.time_zone)
  end

end
