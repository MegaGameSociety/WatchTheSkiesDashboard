class AddImageOrientation < ActiveRecord::Migration[4.2]
  def change
    add_column :news_messages, :media_landscape, :boolean, default: false
  end
end
