class AddIndexToIncomes < ActiveRecord::Migration
  def up
    add_index :income, [:game_id, :team_id, :round], unique: true, name: :game_incomes_index
  end

  def down
    remove_index :income, name: :game_incomes_index
  end
end
