class Game < ActiveRecord::Base
  has_many :bonus_credits
  has_many :incomes
  has_many :messages
  has_many :news_messages
  has_many :public_relations
  has_many :terror_trackers
  has_many :tweets
  has_many :users

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
    self.data = game_data
    self.save()
  end

  def update()
    # If the round isn't paused, check if it is time for the next round
    # Can't have more than 12 rounds.
    if self.round > 13
      self.data['paused'] = true
      self.save()
    end
    # Update round # and next round time if necessary
    unless self.data['paused']
      if self.next_round.utc() < Time.now.utc()
        #First update the income levels
        update_income_levels()

        # Change the round
        puts "Round is changing from #{self.round} to #{self.round+1}"
        self.round +=1
        self.next_round = self.next_round + (30*60)
        self.save
        #Group Twitter activities together and dump cleanly into the error bucket on fail
        begin 
            Tweet.import
            # Send out tweets
            client = Tweet.generate_client
            client.update("Turn #{self.round} has started!")
        rescue => ex
            logger.error ex.message
        end
      end
    end
    return self
  end

  def update_income_levels()
    round = self.round
    # PR > 4, change Income +1
    # PR < -1 and PR < -3, change Income -1
    # PR < -3, change Income -2
    Game::COUNTRIES.each do |country|
      pr = PublicRelation.where(round: round).where(country: country).sum(:pr_amount)
      next_income = Income.where(round: round, team_name: country)[0].amount

      if pr >= 4
        next_income += 1
      elsif pr <=-1 and pr >=-3
        next_income += -1
      elsif pr < -3
        next_income += -2
      end
      income = Income.find_or_create_by(round: Game.last.round + 1, team_name: country)
      income.amount = next_income
      income.save()
    end
  end
end
