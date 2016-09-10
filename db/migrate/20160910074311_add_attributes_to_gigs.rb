class AddAttributesToGigs < ActiveRecord::Migration
  def change
    add_column :gigs, :name, :string
    add_column :gigs, :datetime, :datetime
    add_column :gigs, :link_forum, :string
    add_column :gigs, :vorhandenes_equipment, :text
    add_column :gigs, :status_id, :integer
    add_column :gigs, :band_id, :integer
    add_column :gigs, :user_id, :integer
  end
end
