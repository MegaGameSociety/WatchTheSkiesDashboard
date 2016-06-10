class Reserve < ActiveRecord::Base
  self.table_name = "reserves"
  belongs_to :game
  belongs_to :team
end
