class CreateTerrorTrackers < ActiveRecord::Migration
  def change
    create_table :terror_trackers do |t|
      t.string   "description"
      t.integer  "amount"
      t.integer  "round"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.timestamps null: false
    end
  end
end
