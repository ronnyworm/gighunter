module Rails
	def self.dayname(date)
		case date.wday
		when 1
			"Montag"	
		when 2
			"Dienstag"
		when 3
			"Mittwoch"
		when 4
			"Donnerstag"
		when 5
			"Freitag"
		when 6
			"Samstag"
		else
			"Sonntag"
		end
	end

	def self.daynameshort(date)
		dayname(date)[0..1]
	end

	def self.monthname(date)
		arr = ["~", "Januar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember"]

		return arr[date.month]
	end

	def self.monthnameshort(date)
		monthname(date)[0..2]
	end

	def self.date_diff_today(other_date)
		unless other_date.is_a?(Date)
			return 1000000
		end

		(other_date - Date.today).to_i
	end

	def self.date_relative(date)
		if date.nil?
			return ""
		end

		unless date.is_a?(Date)
			return "bad_date"
		end

		diff = date_diff_today(date)

		case diff
		when 0
			"heute"
		when 1
			"morgen"
		when 2
			"übermorgen"
		when -1
			"gestern"
		when -2
			"vorgestern"
		when 3..7
			"nächsten #{dayname(date)}"
		when -7..-3
			"letzten #{dayname(date)}"
		when 8..365
			"#{daynameshort(date) + " " + date.day.to_s}. #{monthname(date)}"
		when -365..-8
			"#{daynameshort(date) + " " + date.day.to_s}. #{monthname(date)} #{date.year.to_s[2..3]}"
		else
			date.to_s
		end
	end
end