class AddTransferredAtToEmails < ActiveRecord::Migration
  def change
    add_column :emails, :transferred_at, :datetime
  end
end
