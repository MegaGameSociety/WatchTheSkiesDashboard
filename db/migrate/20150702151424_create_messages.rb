class CreateMessages < ActiveRecord::Migration[4.2]
  def change
    create_table :messages do |t|
    	t.string :sender
    	t.string :recipient
        t.string :content
    	t.integer :round_number
    	t.integer :game_id
    	t.timestamps
    end
  end
end
