class NewsMessage < ActiveRecord::Base
  
  # Get all newsfor a given round
  def self.round_news(round)
    NewsMessage.where(round: round)
  end

end
