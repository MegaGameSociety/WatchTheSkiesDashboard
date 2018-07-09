class AddGameToUser < ActiveRecord::Migration[4.2]
  def change
    add_reference :users, :game, index: true
    add_foreign_key :users, :games
  end
end
