class RemoveBandIdFromGigs < ActiveRecord::Migration
  def change
    remove_column :gigs, :band_id, :integer
  end
end
