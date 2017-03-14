class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :what
      t.string :url
      t.boolean :manual

      t.timestamps null: false
    end
  end
end
