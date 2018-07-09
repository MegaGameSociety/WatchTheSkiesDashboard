class CreateGames < ActiveRecord::Migration[4.2]
  def change
    create_table :games do |t|
      t.string :name
      t.integer :round
      t.boolean :alien_comm
      t.json :data
      t.datetime :next_round
      t.timestamps
    end
  end
end
