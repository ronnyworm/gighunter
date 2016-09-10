class Band < ActiveRecord::Base
	has_many :user
	has_many :status_value
	has_many :location
	has_many :contact
end
