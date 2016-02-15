class TweetsController < ApplicationController
  before_action :set_tweet, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_control!

  # GET /tweets
  # GET /tweets.json
  def index
    @private_tweets = Tweet.where(is_public: false).order(tweet_time: :desc)
    @public_tweets = Tweet.where(is_public: true).order(tweet_time: :desc)
  end

  # GET /tweets/1
  # GET /tweets/1.json
  def show
  end

  # GET /tweets/new
  def new
    @tweet = Tweet.new
  end

  # GET /tweets/1/edit
  def edit
  end

  # POST /tweets
  # POST /tweets.json
  def create
    @tweet = Tweet.new(tweet_params)

    respond_to do |format|
      if @tweet.save
        format.html { redirect_to @tweet, notice: 'Tweet was successfully created.' }
        format.json { render :show, status: :created, location: @tweet }
      else
        format.html { render :new }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tweets/1
  # PATCH/PUT /tweets/1.json
  def update
    respond_to do |format|
      if @tweet.update(tweet_params)
        format.html { redirect_to tweets_url, notice: 'Tweet was successfully updated.' }
        format.json { render :show, status: :ok, location: @tweet }
      else
        format.html { render :edit }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tweets/1
  # DELETE /tweets/1.json
  def destroy
    @tweet.destroy
    respond_to do |format|
      format.html { redirect_to tweets_url, notice: 'Tweet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # Import new tweets
  def import_tweets
    count = Tweet.import
    respond_to do |format|
      format.html { redirect_to tweets_path, notice: "Imported #{count} tweets." }
    end
  end

  # Publish tweets
  def export_tweets  
    count = Tweet.export
    respond_to do |format|
      format.html { redirect_to tweets_path, notice: "Published #{count} tweets." }
    end
  end

  #post 
  def toggle_public
    @tweet = Tweet.find(params[:tweet_id])
    @tweet.is_public = !@tweet.is_public
    @tweet.save
    redirect_to tweets_path, notice: "Made #{@tweet.text} #{@tweet.is_public}."
  end

  def publicize_all_tweets
    @tweets = Tweet.where(is_public: false)
    @tweets.update_all(is_public: true)
    redirect_to tweets_path, notice: "Publicized #{@tweets.size} Tweet."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tweet
      @tweet = Tweet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tweet_params
      params[:tweet].permit(:id, :twitter_name, :text, :media_url, :is_public, :is_published)
    end
end
