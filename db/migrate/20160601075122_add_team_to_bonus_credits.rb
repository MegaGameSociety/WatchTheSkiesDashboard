class AddTeamToBonusCredits < ActiveRecord::Migration
  def change
    remove_column :bonus_credits, :team_name
    add_reference :bonus_credits, :team, index: true
    add_foreign_key :bonus_credits, :teams
  end
end
