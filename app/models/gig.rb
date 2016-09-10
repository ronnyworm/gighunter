class Gig < ActiveRecord::Base
	belongs_to :user
	has_many :status
	belongs_to :location

	def current_status
		if status and not status.empty?
			StatusValue.find(status.order(:created_at).first.status_value_id).text
		else
			"(leer)"
		end
	end
end
