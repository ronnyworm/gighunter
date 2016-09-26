class RemoveIsTemplateFromEmail < ActiveRecord::Migration
  def change
    remove_column :emails, :is_template, :boolean
  end
end
