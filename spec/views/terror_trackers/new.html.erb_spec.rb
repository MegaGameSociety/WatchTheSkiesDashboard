require 'rails_helper'

RSpec.describe "terror_trackers/new", :type => :view do
  before(:each) do
    assign(:terror_tracker, TerrorTracker.new())
  end

  it "renders new terror_tracker form" do
    render

    assert_select "form[action=?][method=?]", terror_trackers_path, "post" do
    end
  end
end
