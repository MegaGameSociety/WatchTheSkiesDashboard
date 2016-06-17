class AddActiveToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :visible, :boolean
  end
end
