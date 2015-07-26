class NewsMessagesController < ApplicationController
  before_action :set_news_message, only: [:show, :edit, :update, :destroy]
before_action :authenticate_user!
  # GET /news_messages
  # GET /news_messages.json
  def index
    @current_round = Game.last.round
    @news_messages = NewsMessage.all.order(round: :desc, created_at: :desc)
  end

  # GET /news_messages/1
  # GET /news_messages/1.json
  def show
  end

  # GET /news_messages/new
  def new
    @current_round = Game.last.round
    @news_message = NewsMessage.new
  end

  # GET /news_messages/1/edit
  def edit
  end

  # POST /news_messages
  # POST /news_messages.json
  def create
    @news_message = NewsMessage.new(news_message_params)
    @current_round = Game.last.round

    respond_to do |format|
      if @news_message.save
        format.html { redirect_to @news_message, notice: 'News message was successfully created.' }
        format.json { render :show, status: :created, location: @news_message }
      else
        format.html { render :new }
        format.json { render json: @news_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /news_messages/1
  # PATCH/PUT /news_messages/1.json
  def update
    respond_to do |format|
      if @news_message.update(news_message_params)
        format.html { redirect_to @news_message, notice: 'News message was successfully updated.' }
        format.json { render :show, status: :ok, location: @news_message }
      else
        format.html { render :edit }
        format.json { render json: @news_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /news_messages/1
  # DELETE /news_messages/1.json
  def destroy
    @news_message.destroy
    respond_to do |format|
      format.html { redirect_to news_messages_url, notice: 'News message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_news_message
      @news_message = NewsMessage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def news_message_params
      params[:news_message].permit(:title, :content, :round)
    end
end
