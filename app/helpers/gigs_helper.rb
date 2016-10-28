module GigsHelper
	def without_http(s)
		var = s.gsub(/http:\/\//, "")
		var.gsub(/https:\/\//, "")
	end
end
