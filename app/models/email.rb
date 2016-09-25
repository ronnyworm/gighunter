class Email < ActiveRecord::Base
  belongs_to :gig

  validates :subject, presence: true
  validates :text, presence: true

  def self.get_template
  	Email.where(is_template: true).last
  end
end
