class RemoveBandIdFromTables < ActiveRecord::Migration
  def change
    remove_column :locations, :band_id, :integer
    remove_column :contacts, :band_id, :integer
    remove_column :status_values, :band_id, :integer
  end
end
