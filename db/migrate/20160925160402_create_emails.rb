class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :subject
      t.text :text
      t.boolean :is_template
      t.references :gig, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
