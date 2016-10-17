module ApplicationHelper
	def is_active?(caller)
		if caller.include? "#"
			caller_controller = caller.split("#")[0]
			caller_actions = caller.split("#")[1].split("|")
		elsif caller == controller_name
			return true
		end


		# controller_name ist eine globale Variable von Rails
		if caller_controller != controller_name
			return false
		end

		# action_name ist eine globale Variable von Rails
		caller_actions.each do |a|
			if a == action_name
				return true
			end
		end

		return false
	end

	def nl2br(s)
		s.gsub(/\n/, '<br>')
	end
end
