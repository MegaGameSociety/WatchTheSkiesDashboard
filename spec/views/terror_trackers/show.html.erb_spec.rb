require 'rails_helper'

RSpec.describe "terror_trackers/show", :type => :view do
  before(:each) do
    @terror_tracker = assign(:terror_tracker, TerrorTracker.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
