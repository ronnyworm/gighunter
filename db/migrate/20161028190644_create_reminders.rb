class CreateReminders < ActiveRecord::Migration
  def change
    create_table :reminders do |t|
      t.boolean :done
      t.date :due
      t.text :text
      t.references :gig, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
