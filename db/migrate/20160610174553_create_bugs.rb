class CreateBugs < ActiveRecord::Migration
  def change
    create_table :bugs do |t|
      t.references :game
      t.integer :target
      t.integer :beneficiary
      t.string :klass
      t.datetime :end_time
      t.timestamps
    end
  end
end
