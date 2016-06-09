class MobileDashboardController < ApplicationController
  layout "mobile"

  def index
    @game = current_game
    @current_round = @game.round
    @next_round = @game.next_round.in_time_zone(Time.zone.name)
    @current_terror = @game.terror_trackers.totalTerror()
    @messages = Message.all.order('created_at DESC')
    @newMessage = Message.new
    @teams = Team.all

    begin
      @news = @game.news_messages.round_news(@game.round).order(created_at: :desc)
      if (round>0)
        @news += @game.news_messages.round_news(@game.round-1).order(created_at: :desc)
      end
    rescue
      @status = 500
      @message = "Failure to generate news results."
    end

  end
end
