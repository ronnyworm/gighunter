class Band < ActiveRecord::Base
	has_many :user
	has_many :status_value
end
