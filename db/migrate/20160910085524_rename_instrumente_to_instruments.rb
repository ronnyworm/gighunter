class RenameInstrumenteToInstruments < ActiveRecord::Migration
  def change
  	remove_column :users, :instrumente, :string
  	add_column :users, :instruments, :string
  end
end
