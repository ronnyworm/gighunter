class AddInstrumenteToUsers < ActiveRecord::Migration
  def change
    add_column :users, :instrumente, :string
    add_column :users, :band_id, :integer
  end
end
