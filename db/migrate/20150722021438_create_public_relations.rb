class CreatePublicRelations < ActiveRecord::Migration[4.2]
  def change
    create_table :public_relations do |t|
      t.string :country
      t.string :description
      t.integer :pr_amount
      t.integer :round
      t.boolean :public
      t.timestamps
    end
  end
end
