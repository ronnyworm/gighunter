class Gig < ActiveRecord::Base
	belongs_to :user
	has_many :status

	def current_status
		if status and not status.empty?
			status.order(:created_at).first.status_value.text
		else
			""
		end
	end
end
