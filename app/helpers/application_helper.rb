module ApplicationHelper
	def readable_datetime(dt)
		dt.strftime("%Y-%m-%d %H:%M")
	end
end
