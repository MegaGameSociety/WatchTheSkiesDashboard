
class Tweet < ActiveRecord::Base
  # https://github.com/sferik/twitter
  belongs_to :game

  def convert_to_article
      a = NewsMessage.new
      if !self.media_url.nil?
        if self.media_url.length > 0
          a.media_url = self.media_url
        end
      end

      full_name = "AP"
      if self.twitter_name == "DailyEarthWTS"
        full_name = "DEN"
      elsif self.twitter_name == "GNNWTS"
        full_name = "GNN"
      elsif self.twitter_name == "SFTNews"
        full_name = "S&FT"
      end

      a.title = "#{full_name} reports:"
      a.content = self.text
      a.round = self.game.round
      a.game = self.game
      a.visible_content = true
      a.visible_image = true
      a.save
  end


  def self.import(game)
  # Generate client
  client = Tweet.generate_client
    # Daily Earth News: @DailyEarthWTS
    # GNN: @GNNWTS
    # Science & Financial Times = SFTNews
    den = "DailyEarthWTS"
    gnn = "GNNWTS"
    sft = "SFTNews"
    # Check if there aren't any tweets in database
    tweets = []
    if game.tweets.count()==0
      tweets += (client.user_timeline(den).take(1))
      tweets += (client.user_timeline(gnn).take(1))
      tweets += (client.user_timeline(sft).take(1))
    else
      # get the last timestamp of a tweet and create tweets
      # imported since then
      den_id = Tweet.where(twitter_name: den).order(tweet_time: :asc).last.tweet_id
      client.user_timeline(den, options = {since_id: den_id})
      gnn_id = Tweet.where(twitter_name: gnn).order(tweet_time: :asc).last.tweet_id
      client.user_timeline(gnn, options = {since_id: gnn_id})
      sft_id = Tweet.where(twitter_name: sft).order(tweet_time: :asc).last.tweet_id
      client.user_timeline(sft, options = {since_id: sft_id})
    end

    # Save Tweets
    final_tweets = []
    tweets.each do |tweet|
      #import tweet into system
      t = Tweet.new
      t.twitter_name = tweet.user.screen_name
      t.tweet_id = tweet.id
      t.text = tweet.text.gsub(/http:\/\/[\w\.:\/]+/, '')
      t.is_public = false
      t.is_published = false
      t.tweet_time = tweet.created_at
      t.game = game

      #check if tweet has image
      if tweet.media?
        t.media_url = tweet.media[0].media_url
      end
      t.save
      final_tweets << t
    end
    # Create new articles for each tweet
    final_tweets.each{|t|t.convert_to_article}
    return final_tweets.length
  end

  def self.generate_client
      # Generate client
    client = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['twitter_consumer_key']
      config.consumer_secret = ENV['twitter_consumer_secret']
      config.access_token = ENV['twitter_access_token']
      config.access_token_secret = ENV['twitter_access_token_secret']
    end
    return client
  end

end
