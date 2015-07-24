require 'rails_helper'

RSpec.describe "public_relations/new", :type => :view do
  before(:each) do
    assign(:public_relation, PublicRelation.new())
  end

  it "renders new public_relation form" do
    render

    assert_select "form[action=?][method=?]", public_relations_path, "post" do
    end
  end
end
