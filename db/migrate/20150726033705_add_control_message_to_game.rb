class AddControlMessageToGame < ActiveRecord::Migration[4.2]
  def change
    add_column :games, :control_message, :string

  end
end
