class Contact < ActiveRecord::Base
	has_many :contactlocation

	belongs_to :band

	validates :email, uniqueness: true
	validates :telephone, uniqueness: true
end
