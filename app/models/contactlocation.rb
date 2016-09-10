class Contactlocation < ActiveRecord::Base
	belongs_to :location
	belongs_to :contact
end
