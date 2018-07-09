class AddGameReferences < ActiveRecord::Migration[4.2]
  def change
    add_reference :public_relations, :game, index: true
    add_foreign_key :public_relations, :games

    add_reference :terror_trackers, :game, index: true
    add_foreign_key :terror_trackers, :games

    add_reference :incomes, :game, index: true
    add_foreign_key :incomes, :games

    add_reference :tweets, :game, index: true
    add_foreign_key :tweets, :games
  end
end
