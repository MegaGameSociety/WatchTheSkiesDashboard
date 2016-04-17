class NewsMessage < ActiveRecord::Base
  belongs_to :game
  # Get all newsfor a given round
  def self.round_news(round)
    NewsMessage.where(round: round)
  end

end
