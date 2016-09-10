class Status < ActiveRecord::Base
  belongs_to :gig
  has_one :status_value
end
