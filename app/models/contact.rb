class Contact < ActiveRecord::Base
	has_many :contactlocation

	validates :name, presence: true
	validates :email, uniqueness: true
	validates :telephone, uniqueness: true
end
