class CreateNewsMessages < ActiveRecord::Migration
  def change
    create_table :news_messages do |t|
      t.string :title
      t.string :content
      t.integer :round_number
      t.integer :game_id
      t.timestamps
    end
  end
end
