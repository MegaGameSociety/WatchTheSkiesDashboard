require 'rails_helper'

RSpec.describe "public_relations/show", :type => :view do
  before(:each) do
    @public_relation = assign(:public_relation, PublicRelation.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
