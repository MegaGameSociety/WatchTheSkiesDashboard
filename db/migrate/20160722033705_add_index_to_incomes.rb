class AddIndexToIncomes < ActiveRecord::Migration
  def up
    add_index :incomes, [:game_id, :team_id, :round], unique: true, name: :game_incomes_index
  end

  def down
    remove_index :incomes, name: :game_incomes_index
  end
end
