class AddStagesizeToGigs < ActiveRecord::Migration
  def change
    add_column :gigs, :stagesize, :string
  end
end
