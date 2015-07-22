require 'rails_helper'

RSpec.describe "public_relations/edit", :type => :view do
  before(:each) do
    @public_relation = assign(:public_relation, PublicRelation.create!())
  end

  it "renders the edit public_relation form" do
    render

    assert_select "form[action=?][method=?]", public_relation_path(@public_relation), "post" do
    end
  end
end
