class Game < ActiveRecord::Base
  has_many :bonus_reserves
  has_many :incomes
  has_many :messages
  has_many :news_messages
  has_many :public_relations
  has_many :terror_trackers
  has_many :tweets
  has_many :users

  serialize :game_data, JSON
  COUNTRIES = ['Brazil', 'China', 'France', 'India', 'Japan', 'Russian Federation','United Kingdom', 'USA', 'Germany']

  def reset
    reset_game_data
    reset_terror_track
    reset_countries
    reset_news_and_media
    reset_users
  end

  def reset_game_data
    self.round = 0
    self.next_round = Time.now + 30*60
    self.control_message = 'Welcome to Watch the Skies'
    self.activity = 'All is quiet around the world.'
    game_data = {}
    game_data['rioters']=0
    game_data['paused']=true
    game_data['alien_comms']=false
    self.data = game_data
    self.save
  end

  def reset_terror_track
    self.terror_trackers.destroy_all
    self.terror_trackers.create(
        description: 'Initial Terror',
        amount: 0,
        round: self.round
    )
  end

  def reset_countries
    self.bonus_reserves.destroy_all
    self.incomes.destroy_all
    self.messages.destroy_all
    self.public_relations.destroy_all
    teams = Team.all_without_incomes
    teams.each do |team|
      self.incomes.push(Income.create(
          round: self.round,
          team: team,
          amount: 6
      ))
    end
  end

  def reset_news_and_media
    self.news_messages.destroy_all
    self.tweets.destroy_all
    Tweet.import(self)
  end

  def reset_users
    self.users.where.not(role: ['SuperAdmin', 'Admin']).destroy_all
  end

  def update
    # If the round isn't paused, check if it is time for the next round
    # Can't have more than 12 rounds.
    if self.round > 13
      self.data['paused'] = true
      self.save
    end
    # Update round # and next round time if necessary
    unless self.data['paused']
      if self.next_round.utc() < Time.now.utc()
        unless self.locked
          begin
            self.update_attribute(:locked, true)
            update_income_levels(self.round)
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
            update_income_levels(self.round)
          ensure
            self.update_attribute(:locked, false)
          end
        end
      end
    end
    return self
  end

  # Update income levels based on previous round's pr
  # TODO: Create a cascade update to update incomes from round 0 to current round
  # Almost always, a pr change that needs to be accounted for will only be for the previous round.
  def update_income_levels(round)
    teams = Team.all_without_incomes
    if round == 0
      # Create incomes if none exist for round 0
      if self.incomes.where(round: 0).count == 0
        teams.each do |team|
          #Income starts at 6.
          income = Income.find_or_create_by(game: self, round: round, amount: 6, team: team)
        end
      end
    else
      previous_round = round - 1
      teams.each do |team|
        pr = self.public_relations.where(round: previous_round).where(team: team).sum(:pr_amount)
        previous_income_value = self.incomes.where(round: previous_round, team: team).sum(:amount)
        current_income_value = previous_income_value + self.calculate_income_level(pr)

        begin
          current_income = Income.find_or_create_by(round: round, team: team, game: self)
          current_income.update_attribute(:amount, current_income_value)
        rescue ActiveRecord::RecordNotUnique => e
          # If we hit a race condition on for creating new incomes, check before skipping
          if Income.where(round: round, team: team, game: self).count > 0
            continue
          else
            raise
          end
        end
      end
    end
  end

  def export_data(round)
    round = round.to_i
    @data = self.data

    income_list = self.incomes.where(round: round).group(:team_name).sum(:amount)
    bonus_reserves = self.bonus_reserves.where(round: round, recurring: false).group(:team_name).sum(:amount)
    recurring_credits = self.bonus_reserves.where(recurring: true).group(:team_name).sum(:amount)

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
      "bonus_reserves" => bonus_reserves,
      "recurring_credits" => recurring_credits,
    }
  end

  def next_round
    super.in_time_zone(self.time_zone)
  end

  protected

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
