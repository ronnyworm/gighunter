class AddOrderToStatusValues < ActiveRecord::Migration
  def change
    add_column :status_values, :order, :integer
  end
end
