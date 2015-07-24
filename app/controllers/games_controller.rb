class GamesController < ApplicationController

  def dashboard
    @game = Game.last().update
    @data = JSON.parse(@game.data)

  end

private

end
