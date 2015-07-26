class GamesController < ApplicationController
before_action :authenticate_user!, except:[:dashboard]

  # Main Dashboard for All Players
  def dashboard
    @game = Game.last.update
    @data = @game.getData
  end

  # Human Control dashboard to quickly see PR's
  def human_control
    @last_round = (Game.last.round) -1
    @pr_amounts = PublicRelation.round_pr(@last_round-1)
    @current_round = Game.last.round
    @public_relations = PublicRelation.all.order(round: :desc, created_at: :desc)
    @countries = Game::COUNTRIES
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
    redirect_to human_control_path
  end


  # Administrative stuff for Kevin
  def admin_control
    @game = Game.last
    @time = @game.next_round.in_time_zone('America/New_York')
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
    data = @game.getData
    data['rioters'] = params[:game][:rioters]
    @game.data = data.to_json
    @game.save
    redirect_to terror_trackers_path
  end

  # Post
  def reset
    Game.last.reset
  end

  # Post
  def toggle_game_status
    @game = Game.last
    data = @game.getData
    # if game is not paused, then add 5 to clock
    unless data['paused']
      @game.next_round = @game.next_round + 5 * 60
    end
    data['paused'] = !data['paused']
    @game.data = data.to_json
    @game.save
    redirect_to admin_control_path
  end

  # Post
  def update_time
    @game = Game.find(params[:id])
    dateObj = params["game"]
    datetime = Time.new(dateObj["next_round(1i)"].to_i, dateObj["next_round(2i)"].to_i, 
                        dateObj["next_round(3i)"].to_i, dateObj["next_round(4i)"].to_i,
                        dateObj["next_round(5i)"].to_i)
    @game.next_round = datetime.in_time_zone('Eastern Time (US & Canada)')
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
