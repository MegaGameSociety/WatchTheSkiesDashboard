class AddTeamToPublicRelations < ActiveRecord::Migration[4.2]
  def change
    remove_column :public_relations, :country
    add_reference :public_relations, :team, index: true
    add_foreign_key :public_relations, :teams
  end
end
