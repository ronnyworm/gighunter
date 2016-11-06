class GigMailer < ApplicationMailer
  default from: ENV["GIG_HUNTER_MAIL_SENDER"]

  def apply_contact(mail_object, recipient)
  	@text = mail_object.text

  	mail(to: recipient, bcc: ENV["GIG_HUNTER_MAIL_BCC"], subject: mail_object.subject)
  end
end
