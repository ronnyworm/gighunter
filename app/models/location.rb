class Location < ActiveRecord::Base
	has_many :gig
	has_many :contactlocation
	belongs_to :band

	validates :name, presence: true
	validates :name, uniqueness: true
	validates :address, uniqueness: true
	validates :website, uniqueness: true
end
