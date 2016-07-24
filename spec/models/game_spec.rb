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
    game.reset
    expect(game.name).to eq("")
    expect(game.round).to eq(0)
    expect(game.data).to eq({
                              "rioters" => 0,
                              "paused" => true,
                              "alien_comms" => false
    })
  end

  describe 'income levels' do
    it 'calculates changes in income levels when given a pr amount' do
      expect(game.send(:calculate_income_level, 4)).to eq(1)
      expect(game.send(:calculate_income_level, 2)).to eq(0)
      expect(game.send(:calculate_income_level, -2)).to eq(-1)
      expect(game.send(:calculate_income_level, -5)).to eq(-2)
    end

    it 'does not make PR updates in round 0' do
      expect(game.update_income_levels(0)).to_not change{game.incomes.count}
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
