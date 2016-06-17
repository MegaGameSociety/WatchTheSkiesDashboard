class AddVisibleFlagToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :visible, :boolean, default: false
  end
end
