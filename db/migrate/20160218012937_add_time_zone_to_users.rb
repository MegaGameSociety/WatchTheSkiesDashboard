class AddTimeZoneToUsers < ActiveRecord::Migration
  def change
    add_column :users, :time_zone, :string, :limit => 255, :default => "Pacific Time (US & Canada)"
  end
end
