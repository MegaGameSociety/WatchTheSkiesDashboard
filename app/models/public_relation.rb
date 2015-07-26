class PublicRelation < ActiveRecord::Base
  
  VALID_SOURCES = ['Rioters', 'UN Crisis', 'Alien Agent', 'Terror', 'Human Operative', 'Sabotage', 
      'UN Bonus', 'News', 'Player Spending', 'Other', 'Tech']

  # Get all PR via source from countries
  def self.country_status(country)
    PublicRelation.where(country: country).group(:round).group(:source).sum(:pr_amount).sort_by{|key,value| key[0]}.reverse!
  end

  # Get all PR amounts for a given round
  def self.round_pr(round)
    PublicRelation.where(round: round).group(:country).group(:source).sum(:pr_amount)
  end
end
