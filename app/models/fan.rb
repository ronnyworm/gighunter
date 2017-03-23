class Fan < ActiveRecord::Base
	belongs_to :user

	validates :responsible_id, presence: true
	validates :name, presence: true
	validates :email, presence: true, uniqueness: true, email: true

	def replace_variables(text, location, date)
		text = text.gsub(/\$fan-name\$/, name)
		text = text.gsub(/\$location-name\$/, location)
		text = text.gsub(/\$responsible\$/, User.find_by(id: responsible_id).name)
		text = text.gsub(/\$date\$/, date)
		text
	end
end
