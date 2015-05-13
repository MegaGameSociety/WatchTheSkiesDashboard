class GamesController < ApplicationController

  def dashboard
    @game = Game.first()
    @data = JSON.parse(@game.data)
  end


private
  # method to make all internal checks to the game status
  def updateGame(game)
    # If the round isn't paused, check if it is time for the next round

    # Update round # and next round time if necessary

  end

end
