
class Tweet < ActiveRecord::Base
  # https://github.com/sferik/twitter

  def publish(client)
    if self.is_public && !self.is_published
      # Need to add source + char, limit.
      # GNN:
      # DEN:
      # SFT: 

      if self.media_url.length > 0
        url = URI.parse(self.media_url)
        image = open(url)
        client.update_with_media(self.text, image)
      else
        client.update(self.text)
      end

      self.is_published = true
      self.save
      self.convert_to_article

    end
  end

  def convert_to_article
      a = Article.new
      if self.media_url.length > 0
        a.media_url = self.media_url
      end
      a.title = "#{self.twitter_name} reports:"
      a.content = self.text
      a.round = Game.last.round
      a.save

  end


  def self.import()
  
  # Generate client
  client = Tweet.generate_client
    # Daily Earth News: @DailyEarthWTS
    # GNN: @GNNWTS
    # Science & Financial Times = SFTNews
    
    # Check if there aren't any tweets in database
    if Tweet.count()==0
      # Load initial set of tweets
        tweets = client.list_timeline('WatchSkies', 'wts-list')
    else
      # get the last timestamp of a tweet and create tweets
      # imported since then
      tweets = client.list_timeline('WatchSkies', 'wts-list', {
        since_id: Tweet.objects.last.tweet_id
        })
    end

    # Save Tweets
    tweets.each do |tweet|
      #import tweet into system
      t = Tweet.new
        t.twitter_name = tweet.user.screen_name
        t.tweet_id = tweet.id
        t.text = tweet.text.gsub(/http:\/\/[\w\.:\/]+/, '')
        t.is_public = false
        t.is_published = false
        t.tweet_time = tweet.created_at

        #check if tweet has image
        if tweet.media?
          t.media_url = tweet.media[0].media_url
        end
        t.save
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

  def self.export
    require 'open-uri'
    export_tweets = Tweet.where(is_public: true, is_published: false).order(tweet_time: :asc)
    client = Tweet.generate_client
    export_tweets.each do |tweet|
     tweet.publis(client)
    end
  end
end
