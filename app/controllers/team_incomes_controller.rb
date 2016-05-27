class TeamIncomesController < ApplicationController
  #before_action :authenticate_user!
  #before_action :authenticate_control!

  layout "mobile"

  def index
    @game = current_game
    @current_round = @game.round
    @next_round = @game.next_round.in_time_zone(Time.zone.name)
    @current_terror = @game.terror_trackers.totalTerror()

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
