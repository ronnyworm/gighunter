class AddLocationToGigs < ActiveRecord::Migration
  def change
    add_column :gigs, :location_id, :integer
  end
end
