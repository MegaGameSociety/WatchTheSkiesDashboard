class TerrorTracker < ActiveRecord::Base

  # Get all the Terror accumulated
  def self.totalTerror
    TerrorTracker.sum(:amount)
  end
end
