require 'rails_helper'

def income_for_team(team_name)
  team = Team.find_by_team_name(team_name)
  Income.find_by(team: team)
end

RSpec.describe Income, :type => :model do

  let(:game) { FactoryGirl.create(:game) }

  before(:each) do
    Game::COUNTRIES.each do |country|
      #Income starts at 6.
      team = Team.find_or_create_by(team_name: country)
      income = Income.find_or_create_by(game: game, round: 0, amount: 6, team: team)
    end
  end

  it 'can get amount of credits from income object' do
    income_for_usa = income_for_team('USA')
    income_for_china = income_for_team('China')
    income_for_france = income_for_team('France')

    expect(income_for_usa.credits).to eq(11)
    expect(income_for_china.credits).to eq(10)
    expect(income_for_france.credits).to eq(9)

    income_for_usa.amount = 7
    income_for_china.amount = 7
    income_for_france.amount = 7

    expect(income_for_usa.credits).to eq(13)
    expect(income_for_china.credits).to eq(12)
    expect(income_for_france.credits).to eq(10)
  end

  it 'can get amount of credits from income object when amount higher than expected maximum' do
    income_for_usa = income_for_team('USA')

    income_for_usa.amount = 9
    expect(income_for_usa.credits).to eq(17)
    income_for_usa.amount = 15
    expect(income_for_usa.credits).to eq(17)
  end

  it 'can get amount of credits from income object when amount lower than 1' do
    income_for_usa = income_for_team('USA')

    income_for_usa.amount = 0
    expect(income_for_usa.credits).to eq(0)
  end
end
