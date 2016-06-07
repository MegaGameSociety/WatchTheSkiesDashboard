class Api::ApiController < ApplicationController

  # List of all games
  def games
    # TODO: Limit this only to currently running games.
    respond_to do |format|
      format.json { render :json => Game.select(:id, :name, :round, :next_round, :created_at, :updated_at) }
    end
  end

  def dashboard
    if params[:game_id].nil?
      @game = current_game
    else
      @game = Game.find_by_id(params[:game_id])
    end
    @game.update

    round = @game.round
    @data = @game.data
    begin
      @global_terror = {
        'activity' => @game.activity,
        'total'=> @game.terror_trackers.totalTerror(),
        'rioters'=> @data['rioters']
      }
    rescue
      @status = 500
      @message = "Failure to generate global terror results."
    end

    begin
      @news = @game.news_messages.round_news(round).order(created_at: :desc).limit(10)
      if (round>0)
        @news += @game.news_messages.round_news(round-1).order(created_at: :desc).limit(10)
      end
    rescue
      @status = 500
      @message = "Failure to generate news results."
    end

    begin
      current_income_list = @game.incomes.where(round: round).pluck(:team_name, :amount)
      previous_income_list = @game.incomes.where(round: (round -1)).pluck_to_hash(:team_name, :amount).group_by{|x| x[:team_name]}

      countries_data = current_income_list.map do |country, amount|
        previous_income = previous_income_list[country]

        income_change = if previous_income.nil? or previous_income.empty?
          amount
        else
          amount - previous_income[0][:amount]
        end

        this_country = {
          :name => country,
          :amount => amount,
          :change => income_change
        }
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
        "countries" => countries_data,
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

  # Get Team & Team Role & Permissions info for the Mobile App.
  def mobile_basic
    @game = params[:game_id].nil? ? current_game : Game.find_by_id(params[:game_id])
    @game.update

    user_team = Team.find_by_id(current_user.team_id)
    user_team_role = TeamRole.find_by_id(current_user.team_role_id)

    begin
      #generate overall embedded result
      @result = {
        'team' => user_team,
        'team_role' => user_team_role
      }
    rescue
      @status = 500
      @message = "Failure to generate mobile basic results."
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

  # Get Public Relations / Income info for the Mobile App - Income Tab.
  def income
    @game = params[:game_id].nil? ? current_game : Game.find_by_id(params[:game_id])
    @game.update

    round = @game.round
    public_relations_list = PublicRelation.where(game: @game)

    begin
      #generate overall embedded result
      @result = {
        "timer" => {
          "round"=>  round,
        },
        "pr" => public_relations_list
      }
    rescue
      @status = 500
      @message = "Failure to generate public relation results."
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

 # Get Message Data for the Mobile App - Messages Tab.
  def messages
    @game = params[:game_id].nil? ? current_game : Game.find_by_id(params[:game_id])
    @game.update

    round = @game.round
    messages = Message.all.order('created_at DESC')

    begin
      #generate overall embedded result
      @result = {
        "messages" => messages,
        "new_message" => Message.new
      }
    rescue
      @status = 500
      @message = "Failure to generate message results."
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
