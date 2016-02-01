class NewsPlayersController < ApplicationController
  before_action :authenticate_role!
  # GET /news_messages
  # GET /news_messages.json
  def index
    @current_round = Game.last.round
    @news_messages = NewsMessage.all.order(round: :desc, created_at: :desc)
    @papers = NewsMessage.uniq.pluck(:round).sort
  end

  def toggle_paper_content
    @news = NewsMessage.find(params[:news_id])
    @news.visible_content = !@news.visible_content
    @news.save
    redirect_to news_players_index_path, notice: "Made #{@news.content} visibility #{@news.visible_content}."
  end

  def toggle_paper_media
    @news = NewsMessage.find(params[:news_id])
    @news.visible_image = !@news.visible_image
    @news.save
    redirect_to news_players_index_path, notice: "Made #{@news.content} visibility #{@news.visible_image}."
  end

end
