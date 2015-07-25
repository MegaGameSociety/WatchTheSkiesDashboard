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

private

end
