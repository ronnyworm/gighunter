class Location < ActiveRecord::Base
	has_many :gig
	has_many :contactlocation
	belongs_to :band

	validates :name, presence: true
	validates :festival, presence: true
	validates :name, uniqueness: true
	validates :address, uniqueness: true
	validates :website, uniqueness: true

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
