class FixBugColumns < ActiveRecord::Migration
  def change
    rename_column :bugs, :target, :target_id
    rename_column :bugs, :beneficiary, :beneficiary_id
  end
end
