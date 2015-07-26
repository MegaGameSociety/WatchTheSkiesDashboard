class Api::ApiController < ApplicationController
  def dashboard
    @game = Game.last().update
    @data = @game.getData
    begin
      @global_terror = {
        'total'=> TerrorTracker.totalTerror(),
        'rioters'=> @data['rioters']
      }
    rescue
      @status = 500
      @message = "Failure to generate global terror results."
    end

    begin
      @countries_data = {}
      Game::COUNTRIES.each do |country|
        @countries_data[country] = 0<PublicRelation.where(round: @game.round, country: country).sum("pr_amount")
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
          "next_round" =>  @game.next_round.in_time_zone('America/New_York'),
          "paused" => @data['paused'],
        },
        "global_terror" => @global_terror,
        "countries" => @countries_data
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
