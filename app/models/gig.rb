class Gig < ActiveRecord::Base
	belongs_to :user
	has_many :status
	belongs_to :location

	validates :location_id, presence: true
	validates :name, presence: true
	validates :datetime, presence: true
	validates_format_of :datetime, :with => /(\d\d\d\d-\d\d-\d\d \d\d:\d\d)|(\d\d\d\d-\d\d-\d\d)/

	def current_status
		if status and not status.empty?
			StatusValue.find(status.order(:created_at).first.status_value_id).text
		else
			"(leer)"
		end
	end

	def contact
		if location
			if location.contactlocation
				if location.contactlocation.first
					if location.contactlocation.first.contact
						c = location.contactlocation.first.contact
						return c
					end
				end
			end
		end

		nil
	end

	def datetimereadable
		if datetime
			datetime.strftime("%Y-%m-%d %H:%M")
		else
			""
		end
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
