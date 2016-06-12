class Income < ActiveRecord::Base
  belongs_to :game
  belongs_to :team

  def team_name
    self.team.team_name
  end
end
