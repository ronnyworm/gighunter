class Contact < ActiveRecord::Base
	has_many :contactlocation

	belongs_to :band

	validates :name, presence: true
	validates :email, uniqueness: true
	validates :telephone, uniqueness: true
end
