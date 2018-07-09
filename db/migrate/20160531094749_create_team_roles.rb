class CreateTeamRoles < ActiveRecord::Migration[4.2]
  def change
    create_table :team_roles do |t|
      t.string   :role_name
      t.string   :role_display_name
      t.string   :role_permissions, array: true, default: []
      t.timestamps
    end
  end
end
