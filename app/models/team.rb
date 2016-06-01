class Team < ActiveRecord::Base
  belongs_to :user
  has_many :income
  has_many :bonus_credit
  has_many :public_relation
end
