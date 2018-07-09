class ChangeGameTimeZoneDefault < ActiveRecord::Migration[4.2]
  def change
    change_column_default(:games, :time_zone, "UTC")
  end
end
