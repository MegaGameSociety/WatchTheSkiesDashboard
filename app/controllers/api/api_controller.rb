class Api::ApiController < ApplicationController

  # List of all games
  def games
    # TODO: Limit this only to currently running games.
    respond_to do |format|
      format.json { render :json => Game.select(:id, :name, :round, :next_round, :created_at, :updated_at) }
    end
  end

  def dashboard
    @game = params[:game_id].nil? ? current_game : Game.find_by_id(params[:game_id])
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
      current_income_list = @game.incomes.where(round: round).pluck(:team_id, :amount)
      previous_income_list = @game.incomes.where(round: (round -1)).pluck_to_hash(:team_id, :amount).group_by{|x| x[:team_id]}
      teams = Team.all

      countries_data = current_income_list.map do |team_id, amount|
        team = teams.find(team_id)

        previous_income = previous_income_list[team.team_name]
        income_change = if previous_income.nil? or previous_income.empty?
          amount
        else
          amount - previous_income[0][:amount]
        end

        this_country = {
          :name => team.team_name,
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
          "next_round" =>  @game.next_round.in_time_zone(@game.time_zone).to_i,
          "current_time" =>  Time.now.in_time_zone(@game.time_zone).to_i,
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

    teams = Team.all
    user_team = Team.find_by_id(current_user.team_id)
    user_team_role = TeamRole.find_by_id(current_user.team_role_id)

    begin
      #generate overall embedded result
      @result = {
        'teams' => teams,
        'team' => user_team,
        'team_role' => user_team_role,
        "alien_comms" => @game.data["alien_comms"],
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
    user_team = Team.find_by_id(current_user.team_id)

    public_relations_list = PublicRelation.where(game: @game, team: user_team, round: round - 1)

    # TO DO: This is in progress of being renamed.
    team_bonus_credits = BonusCredit.find_by(game: @game, round: round, team: user_team)
    reserves = team_bonus_credits ? team_bonus_credits.amount : 0

    team_income = Income.find_by(game: @game, round: round, team: user_team)
    income_level = team_income ? team_income.amount : 0
    income_value = team_income ? team_income.credits : 0

    begin
      #generate overall embedded result
      @result = {
        "timer" => {
          "round"=>  round,
        },
        "pr" => public_relations_list,
        "income_level" => income_level,
        "reserves" => reserves,
        "income_value" => income_value,
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

    user_team_id = current_user.team_id
    # @messages = Message.where(game: current_game).
    #     where("(sender_id = ? AND recipient_id = ?) OR 
    #       (sender_id = ? AND recipient_id = ? AND visible = true)",
    #     user_team_id, other_team_id, other_team_id, user_team_id).order(:created_at)
    messages = Message.where(game: @game).
                where("sender_id = ? OR (recipient_id = ? and visible = true)",
                  user_team_id, user_team_id)

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
