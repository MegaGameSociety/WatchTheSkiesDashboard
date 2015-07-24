require 'rails_helper'

RSpec.describe "public_relations/index", :type => :view do
  before(:each) do
    assign(:public_relations, [
      PublicRelation.create!(),
      PublicRelation.create!()
    ])
  end

  it "renders a list of public_relations" do
    render
  end
end
