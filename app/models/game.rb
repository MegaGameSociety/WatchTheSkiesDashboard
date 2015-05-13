class Game < ActiveRecord::Base

  def reset()
    self.name = ""
    self.round = 0
    self.next_round = Time.now() + 30*60
    game_data = {}
    game_data['rioters']=0
    game_data['terror']=0
    game_data['paused']=false
    self.data = game_data.to_json
    self.save()
  end

end
