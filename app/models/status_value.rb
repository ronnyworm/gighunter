class StatusValue < ActiveRecord::Base
	validates :text, uniqueness: true
	validates :text, presence: true
	validates :order, presence: true
	validates :order, uniqueness: true
end
