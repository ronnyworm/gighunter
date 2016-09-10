class Status < ActiveRecord::Base
  belongs_to :gig
  has_one :status_value

  validates :gig_id, presence: true
  validates :status_value_id, presence: true
end
