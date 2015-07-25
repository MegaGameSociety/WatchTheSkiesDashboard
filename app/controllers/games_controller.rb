class GamesController < ApplicationController

  def dashboard
    @game = Game.last().update
    @data = JSON.parse(@game.data)

  end

  def human_control
    @public_relations = PublicRelation.all.order(round: :desc, created_at: :desc)
    @countries = Game.countries()
  end

private

end
