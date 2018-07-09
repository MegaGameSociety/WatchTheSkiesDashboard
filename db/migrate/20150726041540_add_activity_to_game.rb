class AddActivityToGame < ActiveRecord::Migration[4.2]
  def change
    add_column :games, :activity, :string
  end
end
