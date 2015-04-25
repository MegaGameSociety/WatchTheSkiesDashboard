class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :name
      t.integer :round
      t.string :data
      t.datetime :next_round
      t.timestamps
    end
  end
end
