class GigMailer < ApplicationMailer
  default from: ENV["GIG_HUNTER_MAIL_SENDER"]]

  def apply_all_contacts
  	each
  		mail(to: one, subject: subject)
  	end
  end
end
