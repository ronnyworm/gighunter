class AddNameToBands < ActiveRecord::Migration
  def change
    add_column :bands, :name, :string
  end
end
