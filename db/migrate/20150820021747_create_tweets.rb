class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :twitter_name
      t.decimal :tweet_id
      t.string :text
      t.string :media_url
      t.boolean :is_public
      t.boolean :is_published
      t.datetime :tweet_time
      t.timestamps
    end
  end
end

