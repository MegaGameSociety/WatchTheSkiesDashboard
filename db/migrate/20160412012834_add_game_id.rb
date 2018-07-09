class AddGameId < ActiveRecord::Migration[4.2]
  def change
    add_column :bonus_credits, :game_id, :integer
  end
end
