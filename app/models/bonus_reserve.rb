class BonusReserve < ActiveRecord::Base
  belongs_to :game
  belongs_to :team
end
