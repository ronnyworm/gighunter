class Email < ActiveRecord::Base
  belongs_to :gig
  has_one :email_type

  validates :subject, presence: true
  validates :text, presence: true
  validates :email_type_id, presence: true

  def type
  	email_type.text
  end

  def self.get_template
  	template_type = EmailType.find_by(text: "is_template")

  	raise "rake db:seed!" unless template_type

  	Email.where(email_type_id: template_type.id).last
  end
end
