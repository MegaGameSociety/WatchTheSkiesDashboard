require 'rails_helper'

RSpec.describe "terror_trackers/edit", :type => :view do
  before(:each) do
    @terror_tracker = assign(:terror_tracker, TerrorTracker.create!())
  end

  it "renders the edit terror_tracker form" do
    render

    assert_select "form[action=?][method=?]", terror_tracker_path(@terror_tracker), "post" do
    end
  end
end
