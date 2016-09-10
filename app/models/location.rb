class Location < ActiveRecord::Base
	has_many :gig
	has_many :contactlocation
end
