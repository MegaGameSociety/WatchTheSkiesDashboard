class GamesController < ApplicationController

  # Main Dashboard for All Players
  def dashboard
    @game = Game.last().update
    @data = JSON.parse(@game.data)

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
    
    #Game was paused
    unless @game.data['paused']
      @game.next_round = @game.next_round + 5 * 60
    end
    @game.data['paused'] = !@game.data['paused']
    @game.save
    redirect_to admin_controls_path
  end


private

end
