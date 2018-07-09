class AddTweetLockToGames < ActiveRecord::Migration[4.2]
  def change
    add_column :games, :tweets_locked, :boolean, default: false
  end
end
