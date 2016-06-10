class Team < ActiveRecord::Base
  has_many :user
  has_many :income
  has_many :bonus_credit
  has_many :public_relation

  def self.countries
    self.pluck(:team_name).delete_if {|x| x == "Aliens"}
  end

  def self.all_minus_aliens
    self.all.where.not(team_name: "Aliens")
  end
  
  def to_s
    team_name
  end
end
