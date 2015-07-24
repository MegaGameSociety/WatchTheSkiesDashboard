require "rails_helper"

RSpec.describe TerrorTrackersController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/terror_trackers").to route_to("terror_trackers#index")
    end

    it "routes to #new" do
      expect(:get => "/terror_trackers/new").to route_to("terror_trackers#new")
    end

    it "routes to #show" do
      expect(:get => "/terror_trackers/1").to route_to("terror_trackers#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/terror_trackers/1/edit").to route_to("terror_trackers#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/terror_trackers").to route_to("terror_trackers#create")
    end

    it "routes to #update" do
      expect(:put => "/terror_trackers/1").to route_to("terror_trackers#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/terror_trackers/1").to route_to("terror_trackers#destroy", :id => "1")
    end

  end
end
