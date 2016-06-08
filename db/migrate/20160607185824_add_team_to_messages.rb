class AddTeamToMessages < ActiveRecord::Migration
  def change
    remove_column :messages, :sender
    remove_column :messages, :recipient

    add_reference :messages, :sender, references: :team, index: true
    add_foreign_key :messages, :teams, column: :sender_id

    add_reference :messages, :recipient, references: :team, index: true
    add_foreign_key :messages, :teams, column: :recipient_id
  end
end
