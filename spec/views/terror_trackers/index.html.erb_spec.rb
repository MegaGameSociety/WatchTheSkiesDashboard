require 'rails_helper'

RSpec.describe "terror_trackers/index", :type => :view do
  before(:each) do
    assign(:terror_trackers, [
      TerrorTracker.create!(),
      TerrorTracker.create!()
    ])
  end

  it "renders a list of terror_trackers" do
    render
  end
end
