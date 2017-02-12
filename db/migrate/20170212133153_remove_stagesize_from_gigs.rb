class RemoveStagesizeFromGigs < ActiveRecord::Migration
  def change
  	remove_column :gigs, :stagesize, :string
  end
end
