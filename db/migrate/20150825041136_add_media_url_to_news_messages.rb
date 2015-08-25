class AddMediaUrlToNewsMessages < ActiveRecord::Migration
  def change
    add_column :news_messages, :media_url, :string
  end
end
