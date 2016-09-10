class RemoveStatusIdFromGigs < ActiveRecord::Migration
  def change
    remove_column :gigs, :status_id, :integer
  end
end
