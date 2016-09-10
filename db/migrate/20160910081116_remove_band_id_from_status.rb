class RemoveBandIdFromStatus < ActiveRecord::Migration
  def change
    remove_column :statuses, :band_id, :integer
  end
end
