class AddSourceToPublicRelations < ActiveRecord::Migration
  def change
    add_column :public_relations, :source, :string
  end
end
