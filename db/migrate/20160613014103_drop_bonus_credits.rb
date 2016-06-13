class DropBonusCredits < ActiveRecord::Migration
  def change
    drop_table :bonus_credits
  end
end
