class AddActivityToGame < ActiveRecord::Migration
  def change
    add_column :games, :activity, :string
  end
end
