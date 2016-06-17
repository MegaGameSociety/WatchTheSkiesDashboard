class AddDefaultToActive < ActiveRecord::Migration
  def change
    change_column :messages, :visible, :boolean, null: false, default: false
  end
end
