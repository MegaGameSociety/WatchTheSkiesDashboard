require "rails_helper"

RSpec.describe PublicRelationsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/public_relations").to route_to("public_relations#index")
    end

    it "routes to #new" do
      expect(:get => "/public_relations/new").to route_to("public_relations#new")
    end

    it "routes to #show" do
      expect(:get => "/public_relations/1").to route_to("public_relations#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/public_relations/1/edit").to route_to("public_relations#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/public_relations").to route_to("public_relations#create")
    end

    it "routes to #update" do
      expect(:put => "/public_relations/1").to route_to("public_relations#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/public_relations/1").to route_to("public_relations#destroy", :id => "1")
    end

  end
end
