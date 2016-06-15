class GamesController < ApplicationController
 before_action :authenticate_user!, except:[:dashboard]
 before_action :authenticate_control!, except:[:dashboard]

  # Main Dashboard for All Players
  def dashboard
    @game = current_game
    @data = @game.data

    if current_user.role == 'Player'
      redirect_to url_for(:controller => :mobile_dashboard, :action => :index)
    end
  end

  # Human Control dashboard to quickly see PR's
  def human_control
    @game = current_game
    @last_round = (@game.round) -1

    @pr_amounts = PublicRelation.where(game: @game)
      .joins(:team)
      .select("teams.team_name as team_name")
      .group(:team_name)
      .sum(:pr_amount)

    @current_round = @game.round
    @public_relations = @game.public_relations.order(
                                                  round: :desc,
                                                  created_at: :desc
                                                )
    @countries = Team.countries
    @teams = Team.all_without_incomes

    #To Do: Move income values into stored structure somewhere
    @income_values = {}
    @income_values['Brazil'] =[2,5,6,7,8,9,10,11,12]
    @income_values['China']= [2,3,5,7,9,10,12,14,16]
    @income_values['France']= [2,5,6,7,8,9,10,11,12]
    @income_values['India']= [2,5,6,7,8,9,10,11,12]
    @income_values['Japan']= [3,5,6,8,9,10,12,13,14]
    @income_values['Russian Federation'] = [2,4,5,6,7,8,9,10,11]
    @income_values['United Kingdom'] =[2,4,6,7,8,9,10,11,12]
    @income_values['USA']= [1,3,5,7,9,11,13,15,17]
    @income_values['Germany'] =[2,5,6,7,8,9,10,12,14]

    # Todo: Refactor this so that we get the team name with the income
    @incomes = @game.incomes.where(round: @current_round)
    if @last_round > 0
      @previous_income = @game.incomes.where(round: @last_round)
    end
  end

  def update_den
    @game = current_game
    @game.den = params[:game][:den]
    @game.save
    redirect_to admin_control_path
  end

  def update_gnn
    @game = current_game
    @game.gnn = params[:game][:gnn]
    @game.save
    redirect_to admin_control_path
  end

  def update_sft
    @game = current_game
    @game.sft = params[:game][:sft]
    @game.save
    redirect_to admin_control_path
  end

  def create_human_pr
    data = params['human_bulk_pr']
    round = data['round']
    main_values_exist = (data['main_description'] != '' or data['main_pr_amount'] != '')
    results = []
    team_hash = Hash[*Team.select(:id, :team_name).collect{|t| [t.team_name, t.id]}.flatten]
    data['countries'].each do|country_name, country_data|
      if (!main_values_exist and country_data['description'] == '' and country_data['pr_amount'] == '')
        next
      end
      pr = PublicRelation.new
      pr.team_id = team_hash[country_name]
      pr.round = round
      if country_data['description'] == ''
        pr.description = data['main_description']
      else
        pr.description = country_data['description']
      end
      if country_data['pr_amount'] == ''
        pr.pr_amount = data['main_pr_amount']
      else
        pr.pr_amount = country_data['pr_amount']
      end

      if country_data['source'] == ''
        pr.source = data['main_source']
      else
        pr.source = country_data['source']
      end
      pr.save
      results.push(pr)
    end
    current_game.public_relations.push(results)
    respond_to do |format|
      format.html{redirect_to human_control_path, notice: "Entered in #{results.length} for Round: #{round}."}
    end
  end


  # Administrative stuff for Kevin
  def admin_control
    @game = current_game
    @time = @game.next_round.in_time_zone(@game.time_zone)
    render 'admin'
  end

  def update_control_message
    @game = current_game
    @game.control_message = params[:game][:control_message]
    @game.save
    redirect_to admin_control_path
  end

  def update_rioters
    @game = current_game
    data = @game.data
    data['rioters'] = params[:game][:rioters]
    @game.data = data
    @game.save
    redirect_to terror_trackers_path
  end

  def update_round
    @game = current_game
    @game.round = params[:game][:round]
    @game.update_income_levels
    @game.save

    redirect_to admin_control_path
  end

  def export_data
    game = current_game
    round = params[:round]
    respond_to do |format|
      format.json { render :json => game.export_data(round) }
    end
  end

  # Post
  def reset
    g = current_game
    g.reset
    g.tweets.destroy_all
    g.news_messages.destroy_all
    g.public_relations.destroy_all
    g.terror_trackers.destroy_all
    g.terror_trackers.create(
        description: "Initial Terror",
        amount: 0,
        round: g.round
      )

    g.incomes.destroy_all
    g.bonus_credits.destroy_all

    teams = Team.all_without_incomes
    teams.each do |team|
      g.incomes.push(Income.create(round: g.round, team: team, amount: 6))
    end

    #CleanUp
    redirect_to admin_control_path
  end

  # Post
  def toggle_game_status
    @game = current_game
    data = @game.data
    data['paused'] = !data['paused']
    @game.data = data
    @game.save
    redirect_to admin_control_path
  end

  # Post
  def toggle_alien_comms
    @game = current_game
    data = @game.data
    data['alien_comms'] = !data['alien_comms']
    @game.data = data
    @game.save
    redirect_to admin_control_path
  end

  # Post
  def update_time
    @game = Game.find(params[:id])
    dateObj = params["game"]
    # Assumes local server time is the time and then converts to utc
    datetime = Time.zone.local(dateObj["next_round(1i)"].to_i, dateObj["next_round(2i)"].to_i,
                               dateObj["next_round(3i)"].to_i, dateObj["next_round(4i)"].to_i,
                               dateObj["next_round(5i)"].to_i).utc()
    @game.next_round = datetime
    @game.time_zone = dateObj["time_zone"]
    @game.save
    redirect_to admin_control_path
  end

  # Patch
  def update
    @game.paused = false
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to admin_controls_path, notice: 'Game was successfully updated.' }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def game_params
    params[:game].permit([:next_round, :round, :sft, :gnn, :den])
  end
end
