class RenameBonusCreditsToBonusReserves < ActiveRecord::Migration
  def change
    rename_table :bonus_credits, :bonus_reserves
    remove_column :bonus_reserves, :game_id, :integer
    add_reference :bonus_reserves, :game, index: true
    add_foreign_key :bonus_reserves, :games
  end
end
