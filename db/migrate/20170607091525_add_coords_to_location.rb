class AddCoordsToLocation < ActiveRecord::Migration
  def change
  	add_column :locations, :address_lat, :decimal, precision: 12, scale: 10
  	add_column :locations, :address_lng, :decimal, precision: 12, scale: 10
  end
end
