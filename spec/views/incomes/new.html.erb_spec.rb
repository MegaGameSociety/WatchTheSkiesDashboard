require 'rails_helper'

RSpec.describe "incomes/new", :type => :view do
  before(:each) do
    assign(:income, Income.new())
  end

  xit "renders new income form" do
    render

    assert_select "form[action=?][method=?]", incomes_path, "post" do
    end
  end
end
