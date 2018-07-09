class AddTweetNameToGame < ActiveRecord::Migration[4.2]
  def change
    add_column :games, :den, :string, default: "DailyEarthWTS"
    add_column :games, :gnn, :string, default: "GNNWTS"
    add_column :games, :sft, :string, default: "SFTNews"
  end
end
