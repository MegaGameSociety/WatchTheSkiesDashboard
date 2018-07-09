class AddSourceToPublicRelations < ActiveRecord::Migration[4.2]
  def change
    add_column :public_relations, :source, :string
  end
end
