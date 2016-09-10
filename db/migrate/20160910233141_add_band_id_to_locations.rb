class AddBandIdToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :band_id, :integer
  end
end
