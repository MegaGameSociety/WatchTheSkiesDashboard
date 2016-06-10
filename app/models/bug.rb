class Bug < ActiveRecord::Base
  belongs_to :game
  belongs_to :target, class_name: "Team"
  belongs_to :beneficiary, class_name: "Team"
end
