class AddVisibleFlagToMessages < ActiveRecord::Migration[4.2]
  def change
    add_column :messages, :visible, :boolean, default: false
  end
end
