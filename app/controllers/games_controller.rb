class GamesController < ApplicationController

  # Main Dashboard for All Players
  def dashboard
    @game = Game.last().update
    @data = @game.getData

  end
  # Human Control dashboard to quickly see PR's
  def human_control
    @last_round = Game.last.round
    @pr_amounts = PublicRelation.round_pr(@last_round)
    @public_relations = PublicRelation.all.order(round: :desc, created_at: :desc)
    @countries = Game::COUNTRIES
  end

  # Administrative stuff for Kevin
  def admin_control
    @game = Game.last
    render 'admin'
  end

  # Post
  def reset
    Game.last.reset
  end

  # Post
  def toggle_game_status
    @game = Game.last
    data = @game.getData
    #Game was paused
    unless @game.getData['paused']
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
    @game.next_round = datetime
    @game.save
    redirect_to admin_control_path
  end

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
