require 'rails_helper'
RSpec.describe Game, :type => :model do
  let(:game){ FactoryGirl.build(:game)}

    it 'is an ActiveRecord' do
      expect(game).to be_a ActiveRecord::Base
    end

    it 'can reset itself' do
      game.reset
      expect(game.name).to eq("")
    end
end
