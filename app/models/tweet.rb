
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
    if self.twitter_name.downcase == self.game.den.downcase
      full_name = "DEN"
    elsif self.twitter_name.downcase == self.game.gnn.downcase
      full_name = "GNN"
    elsif self.twitter_name.downcase == self.game.sft.downcase
      full_name = "S&FT"
    end

    a.title = "#{full_name}"
    a.content = self.text
    a.round = self.game.round
    a.game = self.game
    a.visible_content = true
    a.visible_image = true
    a.save
  end


  def self.import(game)
    unless game.tweets_locked
      begin
        # Generate client
        client = Tweet.generate_client
        # Daily Earth News: @DailyEarthWTS
        # GNN: @GNNWTS
        # Science & Financial Times = SFTNews
        # Check if there aren't any tweets in database
        tweets = []
        den = Tweet.where(twitter_name: game.den).where(game: game).order(tweet_time: :asc).last
        gnn = Tweet.where(twitter_name: game.gnn).where(game: game).order(tweet_time: :asc).last
        sft = Tweet.where(twitter_name: game.sft).where(game: game).order(tweet_time: :asc).last

        if den.nil?
          tweets += (client.user_timeline(game.den).take(1))
        else
          tweets += client.user_timeline(game.den, options = {since_id: den.tweet_id})
        end
        if gnn.nil?
          tweets += (client.user_timeline(game.gnn).take(1))
        else
          tweets += client.user_timeline(game.gnn, options = {since_id: gnn.tweet_id})
        end
        if sft.nil?
          tweets += (client.user_timeline(game.sft).take(1))
        else
          tweets += client.user_timeline(game.sft, options = {since_id: sft.tweet_id})
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

      ensure
        game.update_attribute(:tweets_locked, false)
      end
      return final_tweets.length
    end
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
