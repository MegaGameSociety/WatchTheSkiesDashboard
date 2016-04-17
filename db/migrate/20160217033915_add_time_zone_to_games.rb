class AddTimeZoneToGames < ActiveRecord::Migration
  def change
    add_column :games, :time_zone, :string, :limit => 255, :default => "Pacific Time (US & Canada)"
  end
end
