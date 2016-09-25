class Location < ActiveRecord::Base
	has_many :gig
	has_many :contactlocation

	validates :name, presence: true
	validates :name, uniqueness: true
	validates_uniqueness_of :address, :allow_blank => true
	validates_uniqueness_of :website, :allow_blank => true

	def contact
		if contactlocation
			if contactlocation.first
				if contactlocation.first.contact
					c = contactlocation.first.contact
					return c
				end
			end
		end

		nil
	end

	def contact_summary
		c = contact
		if c
			"#{c.name} (#{c.email})"
		else
			"(nicht zugeordnet)"
		end
	end
end
