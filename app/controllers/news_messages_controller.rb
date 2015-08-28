class NewsMessagesController < ApplicationController
  before_action :set_news_message, only: [:show, :edit, :update, :destroy]
before_action :authenticate_user!
  # GET /news_messages
  # GET /news_messages.json
  def index
    @current_round = Game.last.round
    @news_messages = NewsMessage.all.order(round: :desc, created_at: :desc)
    @papers = NewsMessage.uniq.pluck(:round).sort
  end

  # GET /news_messages/1
  # GET /news_messages/1.json
  def show
  end

  # GET /news_messages/new
  def new
    @current_round = Game.last.round
    @news_message = NewsMessage.new
    @news_message.visible_content = true
  end

  # GET /news_messages/1/edit
  def edit
    @current_round = @news_message.round
  end

  # POST /news_messages
  # POST /news_messages.json
  def create
    @news_message = NewsMessage.new(news_message_params)
    if @news_message.title.nil?
      @news_message.title = "AP Reports:"
    end
    @current_round = Game.last.round
    if params[:post_online]
      client = Tweet.generate_client
      client.update("AP: #{@news_message.content}")
    end

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

  def paper
    @round = params[:round]    
    den = NewsMessage.where(round: @round).
            where(title: "Daily Earth News reports:").
            where(visible_content: true)
    gnn = NewsMessage.where(round: @round).
            where(title: "Global News Network reports:").
            where(visible_content: true)
    sft = NewsMessage.where(round: @round).
                      where(title: "Science & Financial Times reports:").
                      where(visible_content: true)
    @news = {
      :DEN => den,
      :GNN => gnn,
      :SFT => sft
    }
  end

  def toggle_paper_content
    @news = NewsMessage.find(params[:news_id])
    @news.visible_content = !@news.visible_content
    @news.save
    redirect_to news_messages_path, notice: "Made #{@news.content} visibility #{@news.visible_content}."
  end

  def toggle_paper_media
    @news = NewsMessage.find(params[:news_id])
    @news.visible_image = !@news.visible_image
    @news.save
    redirect_to news_messages_path, notice: "Made #{@news.content} visibility #{@news.visible_image}."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_news_message
      @news_message = NewsMessage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def news_message_params
      params[:news_message].permit(:title, :content, :round, :media_url, :visible_content, :visible_image)
    end
end
