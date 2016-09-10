class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :text
      t.integer :band_id

      t.timestamps null: false
    end
  end
end
