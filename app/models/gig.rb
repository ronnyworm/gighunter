class Gig < ActiveRecord::Base
	belongs_to :user
	has_many :status
end
