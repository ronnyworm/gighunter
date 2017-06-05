module GigsHelper
	def without_http(s)
		var = s.gsub(/http:\/\//, "")
		var.gsub(/https:\/\//, "")
	end

	def just_domain(s)
		s.gsub(/(.*?)\/.*/,'\1')
	end
end
