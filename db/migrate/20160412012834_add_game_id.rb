class AddGameId < ActiveRecord::Migration
  def change
    add_column :bonus_credits, :game_id, :integer
  end
end
