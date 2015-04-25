class Game < ActiveRecord::Base

  def reset()
    self.name = ""
    self.round = 0
    self.date_time = Time.now() + 30*60
    game_data = {}
    game_data['rioters']=0
    game_data['terror']=0
    game_data['paused']=0
    self.data = game_data
    self.save()
  end

end
