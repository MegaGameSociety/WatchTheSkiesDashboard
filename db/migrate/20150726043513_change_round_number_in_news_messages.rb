class ChangeRoundNumberInNewsMessages < ActiveRecord::Migration[4.2]
  def change
    rename_column :news_messages, :round_number, :round
  end
end
