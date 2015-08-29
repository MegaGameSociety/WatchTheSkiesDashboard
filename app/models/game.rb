class Game < ActiveRecord::Base
  serialize :game_data, JSON
  COUNTRIES = ['Brazil', 'China', 'France', 'India', 'Japan', 'Russian Federation','United Kingdom', 'USA']

  def reset()
    self.name = ""
    self.round = 0
    self.next_round = Time.now() + 30*60
    self.control_message = "Welcome to Watch the Skies"
    self.activity = "All is quiet around the world."
    game_data = {}
    game_data['rioters']=0
    game_data['paused']=true
    game_data['alien_comms']=false
    self.data = game_data.to_json
    self.save()
  end

  def update()
    # If the round isn't paused, check if it is time for the next round
    # Can't have more than 12 rounds.
    if self.round > 13
      data = self.getData
      data['paused'] = true
      self.data = data.to_json
      self.save()
    end
    # Update round # and next round time if necessary
    unless self.getData['paused']
      if self.next_round < Time.now
        Tweet.import
        puts "Round is changing from #{self.round} to #{self.round+1}"
        self.round +=1
        self.next_round = self.next_round + (30*60)
        self.save
        client = Tweet.generate_client
        client.update("Turn #{self.round} has started!")
      end
    end
    return self
  end

  def getData
    JSON.parse(self.data)
  end

end
