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
        update_income_levels()
        #Group Twitter activities together and dump cleanly into the error bucket on fail
        begin
            Tweet.import(self)
            # Send out tweets
            # Disabling tweets
            # client = Tweet.generate_client
            # client.update("Turn #{self.round} has started!")
        rescue => ex
            logger.error ex.message
        end

        # Change the round
        puts "Round is changing from #{self.round} to #{self.round+1}"
        self.round +=1
        self.next_round = self.next_round + (30*60)
        self.save
        #First update the income levels
        update_income_levels()
      end
    end
    return self
  end

  def update_income_levels()
    round = self.round
    
    teams = Team.all_without_incomes
    teams.each do |team|
      turn_0 = calculate_income_level(self.public_relations.where(round: 0).where(team: team).sum(:pr_amount) || 0)
      if (round > 1)
        amount = self.public_relations.where('round < ? and round > 0', [round - 1, 0].max).where(team: team).group(:round).sum(:pr_amount).reduce(6 + turn_0) do |memo, arr|
          _, pr_diff = arr
          [memo + calculate_income_level(pr_diff), 0].max
        end
      else
        amount = 6 + turn_0
      end
      next_income = Income.find_or_create_by(round: round + 1, team: team, game: self)
      next_income.amount = amount
      next_income.save()
    end
  end

  def export_data(round)
    round = round.to_i
    @data = self.data

    income_list = self.incomes.where(round: round).group(:team_name).sum(:amount)
    bonus_credits = self.bonus_credits.where(round: round, recurring: false).group(:team_name).sum(:amount)
    recurring_credits = self.bonus_credits.where(recurring: true).group(:team_name).sum(:amount)

    @global_terror = {
        'activity' => self.activity,
        'total'=> self.terror_trackers.totalTerror(),
        'rioters'=> @data['rioters']
    }
    main_data = {
        "timer" => {
          "round"=>  round,
          "next_round" =>  self.next_round.to_utc,
          "paused" => @data['paused'],
          "control_message" => self.control_message
        },
        "global_terror" => @global_terror,
        "pr" => self.public_relations.where(round: round).group(:country).sum(:pr_amount),
        "last_pr" => self.public_relations.where(round: (round - 1 )).group(:country).sum(:pr_amount),
        "incomes" => income_list,
        "bonus_credits" => bonus_credits,
        "recurring_credits" => recurring_credits,
      }
  end

  def next_round
    super.in_time_zone(self.time_zone)
  end

  private

  def calculate_income_level(pr)
    # PR >= 4, change Income +1
    # PR <= -1 and PR >= -3, change Income -1
    # PR < -3, change Income -2
    if pr >= 4
      return 1
    elsif pr <=-1 and pr >=-3
      return -1
    elsif pr < -3
      return -2
    else
      return 0
    end
  end

end
