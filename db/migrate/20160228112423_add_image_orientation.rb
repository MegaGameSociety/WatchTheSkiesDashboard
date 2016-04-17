class AddImageOrientation < ActiveRecord::Migration
  def change
    add_column :news_messages, :media_landscape, :boolean, default: false
  end
end
