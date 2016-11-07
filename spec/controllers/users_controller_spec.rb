require 'rails_helper'

RSpec.describe UsersController, :type => :controller do
  let(:control){ FactoryGirl.create(:admin)}

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)

  end

  describe 'index' do
    it 'shows only users tied to your game if you are not an admin' do
      control.update_attribute(:role, "Control")
      unowned_game = create(:game)

      user1 = create(:player)
      control.game.users << user1

      user2 = create(:player)
      unowned_game.users << user2

      allow(controller).to receive(:current_user).and_return(control)
      get :index

      expect(controller.instance_variable_get(:@users)).to include(control, user1)
      expect(controller.instance_variable_get(:@users)).not_to include(user2)
    end

    it 'shows all users tied to your game if you are a super admin' do
      unowned_game = create(:game)

      user1 = create(:player)
      control.game.users << user1

      user2 = create(:player)
      unowned_game.users << user2

      allow(controller).to receive(:current_user).and_return(control)
      get :index

      expect(controller.instance_variable_get(:@users)).to include(control, user1, user2)
    end
  end
end
