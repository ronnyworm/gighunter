class CreateFans < ActiveRecord::Migration
  def change
    create_table :fans do |t|
      t.string :name
      t.string :email
      t.references :responsible, references: :users, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
