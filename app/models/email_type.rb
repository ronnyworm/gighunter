class EmailType < ActiveRecord::Base
	validates :text, uniqueness: true
end
