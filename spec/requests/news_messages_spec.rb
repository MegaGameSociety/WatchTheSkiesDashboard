require 'rails_helper'

RSpec.describe "NewsMessages", :type => :request do
  describe "GET /news_messages" do
    xit "works! (now write some real specs)" do
      get news_messages_path
      expect(response).to have_http_status(200)
    end
  end
end
