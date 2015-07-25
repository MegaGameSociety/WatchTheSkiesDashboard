class Game < ActiveRecord::Base

  def reset()
    self.name = ""
    self.round = 0
    self.next_round = Time.now() + 30*60
    game_data = {}
    game_data['rioters']=0
    game_data['paused']=false
    self.data = game_data.to_json
    self.save()
  end

  def update()
    # If the round isn't paused, check if it is time for the next round
    # Can't have more than 12 rounds.
    if self.round > 13
      self.data['paused'] = True
      self.saved
    end
    # Update round # and next round time if necessary
    unless self.data['paused']
      if self.next_round < Time.now
        self.round +=1
        self.next_round = self.next_round + (30*60)
        self.save()
      end
    end
    return self
  end

  # this should be moved into a module
  def self.countries()
    return ['Brazil', 'China', 'France', 'Japan', 'Russian Federation','United Kingdom', 'USA']
  end


end
