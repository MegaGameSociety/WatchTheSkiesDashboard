class TerrorTracker < ActiveRecord::Base
  belongs_to :game
  # Get all the Terror accumulated
  def self.totalTerror
    TerrorTracker.sum(:amount)
  end
end
