class ChangeRoundNumberInNewsMessages < ActiveRecord::Migration
  def change
    rename_column :news_messages, :round_number, :round
  end
end
