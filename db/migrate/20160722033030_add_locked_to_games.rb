class AddLockedToGames < ActiveRecord::Migration[4.2]
  def change
    add_column :games, :locked, :boolean, default: false
  end
end
