class AddTeamAndRoleToUser < ActiveRecord::Migration[4.2]
  def change
    add_reference :users, :team, index: true
    add_foreign_key :users, :teams

    add_reference :users, :team_role, index: true
    add_foreign_key :users, :team_roles
  end
end
