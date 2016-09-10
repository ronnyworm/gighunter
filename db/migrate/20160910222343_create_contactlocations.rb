class CreateContactlocations < ActiveRecord::Migration
  def change
    create_table :contactlocations do |t|
      t.integer :contact_id
      t.integer :location_id

      t.timestamps null: false
    end
  end
end
