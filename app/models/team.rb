class Team < ActiveRecord::Base
  has_many :user
  has_many :income
  has_many :bonus_credit
  has_many :public_relation
end
