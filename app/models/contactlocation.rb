class Contactlocation < ActiveRecord::Base
	belongs_to :location
	belongs_to :contact

	validates :location_id, uniqueness: { scope: [:contact_id] }
end
