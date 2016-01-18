class Api::ApiController < ApplicationController
  def dashboard
    @game = Game.last().update
    round = @game.round
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
      @news = NewsMessage.round_news(round).order(created_at: :desc)
      if (round>0)
        @news += NewsMessage.round_news(round-1).order(created_at: :desc)
      end
    rescue
      @status = 500
      @message = "Failure to generate news results."
    end

    begin
      @countries_data = {}
      countries_calculations = {}
      current_income_list = Income.where(round: round).pluck(:team_name, :amount)
      previous_income_list = Income.where(round: (round -1)).pluck(:team_name, :amount)

      current_income_list.each do |pair|
        countries_calculations[pair[0]] = pair[1]
      end

      unless previous_income_list.empty?
        previous_income_list.each do |pair|
          countries_calculations[pair[0]] -= pair[1]
        end
      end

      countries_calculations.each do |country, amount|
        @countries_data[country] = (amount >= 0)
      end

    rescue
      @status = 500
      @message = "Failure to generate countries"
    end

    begin
      #generate overall embedded result
      @result = {
        "timer" => {
          "round"=>  round,
          "next_round" =>  @game.next_round.in_time_zone(Time.zone.name),
          "paused" => @data['paused'],
          "control_message" => @game.control_message
        },
        "news" =>  @news,
        "global_terror" => @global_terror,
        "countries" => @countries_data,
        "alien_comms" => @data["alien_comms"],
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
