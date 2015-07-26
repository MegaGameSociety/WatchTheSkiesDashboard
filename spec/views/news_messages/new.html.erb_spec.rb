require 'rails_helper'

RSpec.describe "news_messages/new", :type => :view do
  before(:each) do
    assign(:news_message, NewsMessage.new())
  end

  it "renders new news_message form" do
    render

    assert_select "form[action=?][method=?]", news_messages_path, "post" do
    end
  end
end
