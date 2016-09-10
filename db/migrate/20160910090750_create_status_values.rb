class CreateStatusValues < ActiveRecord::Migration
  def change
    create_table :status_values do |t|
      t.string :text
      t.integer :band_id

      t.timestamps null: false
    end
  end
end
