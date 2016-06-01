class PublicRelation < ActiveRecord::Base
  belongs_to :game
  belongs_to :team

  VALID_SOURCES = ['','Rioters', 'UN Crisis', 'Alien Agent', 'Terror', 'Human Operative', 'Sabotage',
      'UN Bonus', 'News', 'Player Spending', 'Other', 'Tech']

  # Get all PR via source from countries
  def self.country_status(team, game)
    game.public_relations.where(team: team).group(:round).group(:source).sum(:pr_amount).sort_by{|key,value| key[0]}.reverse!
  end

  # Get all PR amounts for a given round
  def self.round_pr(round, game)
    game.public_relations.where(round: round).group(:team).group(:source).sum(:pr_amount)
  end
end
