class Location < ActiveRecord::Base
	has_many :gig
	has_many :contactlocation

	validates :name, presence: true
	validates :name, uniqueness: true
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

	def website_without_http
		var = website.gsub(/http:\/\//, "")
		var.gsub(/https:\/\//, "")
	end

	def get_coords
		if address_lat.nil?
			coords = Location.get_coords(address)

			if coords
				self.address_lat = coords[:lat]
				self.address_lng = coords[:lng]

				self.save
			end
		end

		{
			lat: address_lat, 
			lng: address_lng
		}
	end



	def self.get_coords(name)
	    result = Net::HTTP.get(URI.parse("https://maps.google.com/maps/api/geocode/json?address=#{URI.encode(name, /\W/)}&sensor=false"))
	    coords_json = JSON.parse(result)
	    
	    if coords_json["results"].size > 0
			{
				lat: coords_json["results"][0]["geometry"]["location"]["lat"], 
				lng: coords_json["results"][0]["geometry"]["location"]["lng"]
			}
		else
			nil
		end
	end
end
