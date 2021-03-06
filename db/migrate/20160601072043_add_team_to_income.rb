class AddTeamToIncome < ActiveRecord::Migration[4.2]
  def change
    remove_column :incomes, :team_name
    add_reference :incomes, :team, index: true
    add_foreign_key :incomes, :teams
  end
end
