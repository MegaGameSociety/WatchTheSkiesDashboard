class Team < ActiveRecord::Base
  has_many :user
  has_many :income
  has_many :bonus_credit
  has_many :public_relation

  def self.countries
    self.pluck(:team_name).delete_if {|x| x == "Aliens"}
  end

  # Access teams which don't accrue income/pr
  # ToDo: Replace this with a check on a flag
  def self.all_without_incomes
    self.all.where.not(team_name: ["Aliens"])
  end
end
