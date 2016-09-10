class ChangeStatuses < ActiveRecord::Migration
  def change
  	remove_column :statuses, :text, :string
  	add_column :statuses, :gig_id, :integer
  	add_column :statuses, :status_value_id, :integer
  end
end
