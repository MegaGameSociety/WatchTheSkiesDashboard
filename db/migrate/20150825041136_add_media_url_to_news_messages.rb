class AddMediaUrlToNewsMessages < ActiveRecord::Migration[4.2]
  def change
    add_column :news_messages, :media_url, :string
  end
end
