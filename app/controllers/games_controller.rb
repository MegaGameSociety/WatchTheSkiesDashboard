class GamesController < ApplicationController

  def dashboard
    @game = Game.first().update
    @data = JSON.parse(@game.data)

  end

private

end
