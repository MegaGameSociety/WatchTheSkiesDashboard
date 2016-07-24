require 'rails_helper'

RSpec.describe "incomes/show", :type => :view do
  before(:each) do
    @income = assign(:income, Income.create!())
  end

  xit "renders attributes in <p>" do
    render
  end
end
