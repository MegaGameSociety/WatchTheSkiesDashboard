require 'rails_helper'

RSpec.describe "news_messages/edit", :type => :view do
  before(:each) do
    @news_message = assign(:news_message, NewsMessage.create!())
  end

  it "renders the edit news_message form" do
    render

    assert_select "form[action=?][method=?]", news_message_path(@news_message), "post" do
    end
  end
end
