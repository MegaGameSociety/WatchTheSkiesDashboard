class AddTweetLockToGames < ActiveRecord::Migration
  def change
    add_column :games, :tweets_locked, :boolean, default: false
  end
end