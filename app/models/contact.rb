class Contact < ActiveRecord::Base
	has_many :contactlocation

	validates :name, presence: true
	validates_uniqueness_of :email, :allow_blank => true
	validates_uniqueness_of :telephone, :allow_blank => true


	def summary
		"#{name} (#{email})"
	end
end
