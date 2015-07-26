require 'rails_helper'

RSpec.describe "news_messages/show", :type => :view do
  before(:each) do
    @news_message = assign(:news_message, NewsMessage.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
