class AddGameToUser < ActiveRecord::Migration
  def change
    add_reference :users, :game, index: true
    add_foreign_key :users, :games
  end
end
