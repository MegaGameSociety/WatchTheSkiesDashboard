class AddTimeZoneToGames < ActiveRecord::Migration[4.2]
  def change
    add_column :games, :time_zone, :string, :limit => 255, :default => "Pacific Time (US & Canada)"
  end
end
