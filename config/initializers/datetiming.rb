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

		diff_in_seconds = (now - other_date) * 1.days

		if diff_in_seconds < 0
			return "0 Min."
		end

		case diff_in_seconds
		when 0..3598
			"#{(diff_in_seconds / 60).round(0)} Min."
		when 3599..86398
			"#{(diff_in_seconds / 60 / 60).round(0)} Std."
		when 86399..604798
			"#{(diff_in_seconds / 60 / 60 / 24).round(0)} T."
		when 604799..2419198
			"#{(diff_in_seconds / 60 / 60 / 24 / 7).round(0)} Wo."
		when 2419199..31557598
			"#{(diff_in_seconds / 60 / 60 / 24 / 7 / 4.35).round(0)} Mo."
		else
			"#{(diff_in_seconds / 60 / 60 / 24 / 7 / 4.35 / 12).round(0)} J."
		end
	end

	def self.datetime_relative_style(other_date)
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

		diff_in_seconds = (now - other_date) * 1.days

		# ein Monat
		if diff_in_seconds < 2419200
			"color:black;background-color:white"
		# ein Monat bis 3 Monate
		elsif diff_in_seconds >= 2419200 and diff_in_seconds < 7884000
			font_rgb = (diff_in_seconds - 2419200) / (7884000 - 2419200) * 255;
			font_rgb = font_rgb.to_i

			back_rgb = 255 - ((diff_in_seconds - 2419200) / (7884000 - 2419200) * 255);
			back_rgb = back_rgb.to_i

			"color:rgb(255,#{back_rgb - 50},#{back_rgb - 50});background-color:rgb(#{back_rgb},#{back_rgb},#{back_rgb})"
		else
			"color:red;background-color:black"
		end
	end
end