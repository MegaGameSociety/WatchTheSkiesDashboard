class ChangeGameTimeZoneDefault < ActiveRecord::Migration
  def change
    change_column_default(:games, :time_zone, "UTC")
  end
end
