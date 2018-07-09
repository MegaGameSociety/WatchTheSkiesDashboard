class CreateIncomes < ActiveRecord::Migration[4.2]
  def change
    create_table :incomes do |t|
      t.string   "team_name"
      t.integer  "amount"
      t.integer  "round"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
