class GamesController < ApplicationController
before_action :authenticate_user!, except:[:dashboard]

  # Main Dashboard for All Players
  def dashboard
    @game = Game.last.update
    @data = @game.data
  end

  # Human Control dashboard to quickly see PR's
  def human_control
    @last_round = (Game.last.round) -1
    
    @pr_amounts = PublicRelation.where(round: @last_round).group(:country).sum(:pr_amount)
    @current_round = Game.last.round
    @public_relations = PublicRelation.all.order(round: :desc, created_at: :desc)
    @countries = Game::COUNTRIES
    @income_values = {}
    @income_values['Brazil'] =[2,5,6,7,8,9,10,11,12]
    @income_values['China']= [2,3,5,7,9,10,12,14,16]
    @income_values['France']= [2,5,6,7,8,9,10,11,12]
    @income_values['India']= [2,5,6,7,8,9,10,11,12]
    @income_values['Japan']= [3,5,6,8,9,10,12,13,14]
    @income_values['Russian Federation'] = [2,4,5,6,7,8,9,10,11]
    @income_values['United Kingdom'] =[2,4,6,7,8,9,10,11,12]
    @income_values['USA']= [1,3,5,7,9,11,13,15,17]
    @incomes = Income.where(round: @current_round)
    if @last_round > 0
      @previous_income = Income.where(round: @last_round)
    end
  end

  def create_human_pr
    data = params['human_bulk_pr']
    round = data['round']
    main_values_exist = (data['main_description'] != '' or data['main_pr_amount'] != '')
    results = []
    data['countries'].each do|country_name, country_data|
      if (!main_values_exist and country_data['description'] == '' and country_data['pr_amount'] == '')
        next
      end
      pr = PublicRelation.new
      pr.country = country_name
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
    respond_to do |format|
      format.html{redirect_to human_control_path, notice: "Entered in #{results.length} for Round: #{round}."}
    end
  end


  # Administrative stuff for Kevin
  def admin_control
    @game = Game.last
    @time = @game.next_round
    @time_zone = Time.zone.name
    render 'admin'
  end

  def update_control_message
    @game = Game.last
    @game.control_message = params[:game][:control_message]
    @game.save
    redirect_to admin_control_path
  end

  def update_rioters
    @game = Game.last
    data = @game.data
    data['rioters'] = params[:game][:rioters]
    @game.data = data
    @game.save
    redirect_to terror_trackers_path
  end

  def update_round
    @game = Game.last
    @game.round = params[:game][:round]
    @game.save
    redirect_to admin_control_path
  end

  # Post
  def reset
    Game.last.reset
    g = Game.last
    Tweet.delete_all
    NewsMessage.delete_all
    PublicRelation.delete_all
    TerrorTracker.delete_all
    t = TerrorTracker.create(
      description: "Initial Terror",
      amount: 50,
      round: g.round
    )
  end

  # Post
  def toggle_game_status
    @game = Game.last
    data = @game.data
    # if game is not paused, then add 5 to clock
    unless data['paused']
      @game.next_round = @game.next_round + 5 * 60
    end
    data['paused'] = !data['paused']
    @game.data = data
    @game.save
    redirect_to admin_control_path
  end

  # Post
  def toggle_alien_comms
    @game = Game.last
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
      params[:game].permit(:next_round)
  end
end
