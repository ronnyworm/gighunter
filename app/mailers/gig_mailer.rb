class GigMailer < ApplicationMailer
  default from: ENV["GIG_HUNTER_MAIL_SENDER"]

  def self.apply_all_contacts
  	#each
  	#end
  end

  def apply_contact(email)
    # Denke an die Zeilenumbrüche!

  	#t = Email.get_template
  	#@text = 

  	#mail(to: email, subject: subject)
  end
end
