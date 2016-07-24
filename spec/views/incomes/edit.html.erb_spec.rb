require 'rails_helper'

RSpec.describe "incomes/edit", :type => :view do
  before(:each) do
    @income = assign(:income, Income.create!())
  end

  xit "renders the edit income form" do
    render

    assert_select "form[action=?][method=?]", income_path(@income), "post" do
    end
  end
end
