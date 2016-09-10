class AddBandIdToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :band_id, :integer
  end
end
