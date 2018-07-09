class CreateBonusCredits < ActiveRecord::Migration[4.2]
  def change
    create_table :bonus_credits do |t|
      t.string :team_name
      t.boolean :recurring
      t.integer :round
      t.integer :amount
      t.timestamps
    end
  end
end
