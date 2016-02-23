
class Tweet < ActiveRecord::Base
  # https://github.com/sferik/twitter
  belongs_to :game

  def publish(client)
    require 'open-uri'
    # if self.is_public && !self.is_published
    # Disble tweeting
    if false
      # Need to add source + char, limit.
      # GNN:
      # DEN:
      # SFT: 
      short_name = ""
      if self.twitter_name == "DailyEarthWTS"
        short_name = "DEN:"
      elsif self.twitter_name == "GNNWTS"
        short_name = "GNN:"
      elsif self.twitter_name == "SFTNews"
        short_name = "SFT:"
      else
        short_name = "AP:"
      end

      if !self.media_url.nil?
        if self.media_url.length > 0
          url = URI.parse(self.media_url)
          image = open(url)
          client.update_with_media("#{short_name} #{self.text}".slice(0,140-self.media_url.length), image)
        else
          client.update("#{short_name} #{self.text}".slice(0,139))
        end
      else
        client.update("#{short_name} #{self.text}".slice(0,139))
      end

      self.is_published = true
      self.save
      self.convert_to_article
    end
  end

  def convert_to_article
      a = NewsMessage.new
      if !self.media_url.nil?
        if self.media_url.length > 0
          a.media_url = self.media_url
        end
      end

      full_name = "AP"
      if self.twitter_name == "DailyEarthWTS"
        full_name = "Daily Earth News"
      elsif self.twitter_name == "GNNWTS"
        full_name = "Global News Network"
      elsif self.twitter_name == "SFTNews"
        full_name = "Science & Financial Times"
      end

      a.title = "#{full_name} reports:"
      a.content = self.text
      a.round = Game.last.round
      a.visible_content = true
      a.visible_image = true
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
        tweets = client.list_timeline('WatchSkies', 'wts-list').take(3)
    else
      # get the last timestamp of a tweet and create tweets
      # imported since then
      tweets = client.list_timeline('WatchSkies', 'wts-list', {
        since_id: Tweet.order(tweet_time: :asc).last.tweet_id
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
    return tweets.length
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
    export_tweets = Tweet.where(is_public: true, is_published: false).order(tweet_time: :asc)
    client = Tweet.generate_client
    export_tweets.each do |tweet|
      tweet.publish(client)
    end
    return export_tweets.count
  end
end
