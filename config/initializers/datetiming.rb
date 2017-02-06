module Rails
	def self.datetime_relative(other_date)
		if other_date.nil?
			return ""
		end

		if other_date.class == ActiveSupport::TimeWithZone
			other_date = other_date.to_datetime
		end

		unless other_date.is_a?(DateTime)
			return "bad_date (kein DateTime)"
		end

		now = DateTime.now

		diff = (now - other_date) * 1.days

		if diff < 0
			return "bad_date (< 0)"
		end

		case diff
		when 0..3598
			"#{(diff / 60).round(0)} Min."
		when 3599..86398
			"#{(diff / 60 / 60).round(0)} Std."
		when 86399..604798
			"#{(diff / 60 / 60 / 24).round(0)} T."
		when 604799..2419198
			"#{(diff / 60 / 60 / 24 / 7).round(0)} Wo."
		when 2419199..31557598
			"#{(diff / 60 / 60 / 24 / 7 / 4.35).round(0)} Mo."
		else
			"#{(diff / 60 / 60 / 24 / 7 / 4.35 / 12).round(0)} J."
		end
	end
end