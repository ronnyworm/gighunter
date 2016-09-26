class AddEmailTypeToEmail < ActiveRecord::Migration
  def change
    add_reference :emails, :email_type, index: true, foreign_key: true
  end
end
