class Reminder < ActiveRecord::Base
  belongs_to :gig

  validates :text, presence: true
  validates :gig_id, presence: true
  validates_format_of :due, :with => /(\d\d\d\d-\d\d-\d\d)/
end
