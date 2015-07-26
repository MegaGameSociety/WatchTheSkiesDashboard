require 'rails_helper'

RSpec.describe "news_messages/index", :type => :view do
  before(:each) do
    assign(:news_messages, [
      NewsMessage.create!(),
      NewsMessage.create!()
    ])
  end

  it "renders a list of news_messages" do
    render
  end
end
