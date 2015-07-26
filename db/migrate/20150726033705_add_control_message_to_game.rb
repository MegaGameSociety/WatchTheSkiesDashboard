class AddControlMessageToGame < ActiveRecord::Migration
  def change
    add_column :games, :control_message, :string

  end
end
