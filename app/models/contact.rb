class Contact < ActiveRecord::Base
	has_many :contactlocation

	belongs_to :band
end
