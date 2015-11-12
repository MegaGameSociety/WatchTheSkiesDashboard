class Api::ApiController < ApplicationController
  def dashboard
    @game = Game.last().update
    @data = @game.data
    begin
      @global_terror = {
        'activity' => Game.last().activity,
        'total'=> TerrorTracker.totalTerror(),
        'rioters'=> @data['rioters']
      }
    rescue
      @status = 500
      @message = "Failure to generate global terror results."
    end

    begin
      @news = NewsMessage.round_news(@game.round).order(created_at: :desc)
      if ((@game.round)>0)
        @news += NewsMessage.round_news((@game.round)-1).order(created_at: :desc)
      end
    rescue
      @status = 500
      @message = "Failure to generate news results."
    end

    begin
      @countries_data = {}
      Game::COUNTRIES.each do |country|
        @countries_data[country] = 0<=(PublicRelation.where(round: @game.round, country: country).sum("pr_amount") +
          PublicRelation.where(round: @game.round-1, country: "Brazil").sum("pr_amount"))
      end
    rescue
      @status = 500
      @message = "Failure to generate countries"
    end

    begin
      #generate overall embedded result
      @result = {
        "timer" => {
          "round"=>  @game.round,
          "next_round" =>  @game.next_round.in_time_zone(Time.zone.name),
          "paused" => @data['paused'],
          "control_message" => @game.control_message
        },
        "news" =>  @news,
        "global_terror" => @global_terror,
        "countries" => @countries_data,
        'alien_comms' => @data['alien_comms']
      }
    rescue
      @status = 500
      @message = "Failure to generate overall results."
    end

    # if we haven't set a message, we sucessfully made stuff
    unless @message
      @status = 200
      @message = "Success!"
    end

    @response = {
      status: @status,
      message: @message,
      date:  Time.now,
      result: @result
    }

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  private

end
