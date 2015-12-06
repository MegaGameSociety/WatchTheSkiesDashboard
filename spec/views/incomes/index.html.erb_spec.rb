require 'rails_helper'

RSpec.describe "incomes/index", :type => :view do
  before(:each) do
    assign(:incomes, [
      Income.create!(),
      Income.create!()
    ])
  end

  it "renders a list of incomes" do
    render
  end
end
