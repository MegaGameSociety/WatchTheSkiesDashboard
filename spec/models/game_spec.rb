require 'rails_helper'
RSpec.describe Game, :type => :model do
  let(:game){ FactoryGirl.create(:game)}

  Game::COUNTRIES.each{|country| Team.find_or_create_by(team_name: country)}

  before(:each) do
    Game::COUNTRIES.each do |country|
      #Income starts at 6.
      team = Team.find_by_team_name(country)
      income = Income.find_or_create_by(game: game, round: 0, amount: 6, team: team)
    end
  end

  it 'is an ActiveRecord' do
    expect(game).to be_a ActiveRecord::Base
  end

  it 'can reset its own data' do
    initial_game_name = game.name
    allow(Tweet).to receive(:import)
    expect(Tweet).to receive(:import).with(game)

    game.reset

    # Verify reset game data
    expect(game.name).to eq(initial_game_name)
    expect(game.round).to eq(0)
    expect(game.next_round).to be_between(Time.now + 29*60, Time.now + 30*60)
    expect(game.control_message).to eq('Welcome to Watch the Skies')
    expect(game.activity).to eq('All is quiet around the world.')
    expect(game.data).to eq({
                                'rioters' => 0,
                                'paused' => true,
                                'alien_comms' => false
    })

    # Verify reset relations
    expect(game.bonus_credits).to match_array([])
    expect(game.messages).to match_array([])
    expect(game.public_relations).to match_array([])
    expect(game.news_messages).to match_array([])
    expect(game.tweets).to match_array([])

    # Verify reset users
    expect(game.users.count).to eq(1)
    expect(game.users.where(game: game, role: ['SuperAdmin', 'Admin']).count).to eq(1)
    expect(game.users.where.not(game: game, role: ['SuperAdmin', 'Admin']).count).to eq(0)

    # Verify initial incomes
    expect(game.incomes.count).to eq(Game::COUNTRIES.count)
    Game::COUNTRIES.each do |country|
      team = Team.find_by_team_name(country)
      income = game.incomes.where(team: team, round: game.round).first
      expect(income.amount).to eq(6)
    end

    # Verify initial terror trackers
    expect(game.terror_trackers.count).to eq(1)
    expect(game.terror_trackers.first.round).to eq(0)
    expect(game.terror_trackers.first.amount).to eq(0)
    expect(game.terror_trackers.first.description).to eq('Initial Terror')
  end

  describe 'income levels' do
    it 'calculates changes in income levels when given a pr amount' do
      expect(game.send(:calculate_income_level, 4)).to eq(1)
      expect(game.send(:calculate_income_level, 2)).to eq(0)
      expect(game.send(:calculate_income_level, -2)).to eq(-1)
      expect(game.send(:calculate_income_level, -5)).to eq(-2)
    end

    it 'does not make PR updates in round 0' do
      expect{game.update_income_levels(0)}.to_not change{game.incomes.count}
    end

    it 'calculates income levels for next round from previous round pr' do
      # create some PR for previous round
      Game::COUNTRIES.each do |country|
        game.public_relations.push(PublicRelation.create({
           team: Team.find_by_team_name(country),
           round: game.round - 1,
           description: "#{country} description pr",
           pr_amount: 5,
           source: "UN Bonus"
        }))
      end

      # calculate income levels
      game.update_attribute(:round, 1)
      game.update_income_levels(game.round)

      # ensure income levels are in next round
      expect(game.incomes.where(round: game.round).count).to eq(Game::COUNTRIES.length)
      Game::COUNTRIES.each do |country|
        team = Team.find_by_team_name(country)
        income = game.incomes.where(team: team, round: game.round).first
        expect(income.amount).to eq(7)
      end
    end
  end
end
