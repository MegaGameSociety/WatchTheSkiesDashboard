class RenameBonusCreditsToReserves < ActiveRecord::Migration
  def change
    rename_table :bonus_credits, :reserves
  end
end
