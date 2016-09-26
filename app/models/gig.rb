class Gig < ActiveRecord::Base
	belongs_to :user
	has_many :status
	has_many :email
	belongs_to :location

	validates :location_id, presence: true
	validates :name, presence: true
	validates :datetime, presence: true
	validates_format_of :datetime, :with => /(\d\d\d\d-\d\d-\d\d \d\d:\d\d)|(\d\d\d\d-\d\d-\d\d)/

	def current_status
		if status and not status.empty?
			StatusValue.find(status.order(:created_at).last.status_value_id).text
		else
			nil
		end
	end

	def contact
		if location
			if location.contactlocation
				if location.contactlocation.first
					if location.contactlocation.first.contact
						c = location.contactlocation.first.contact
						return c
					end
				end
			end
		end

		nil
	end

	def datetimereadable
		if datetime
			datetime.strftime("%Y-%m-%d %H:%M")
		else
			""
		end
	end
	
	def contact_summary
		c = contact
		if c
			"#{c.name} (#{c.email})"
		else
			"(nicht zugeordnet)"
		end
	end

	def create_apply_email
		apply_created_email_type = EmailType.find_by(text: "apply_created")
		apply_sent_email_type = EmailType.find_by(text: "apply_sent")
  		raise "rake db:seed!" unless apply_created_email_type


		if location and contact
			return false if Email.where(gig_id: id, email_type_id: apply_sent_email_type.id).count > 0

			template = Email.get_template
			apply_created_mails = Email.where(gig_id: id, email_type_id: apply_created_email_type.id)

			if apply_created_mails.count == 0
				# E-Mail erzeugen
				unless Email.create(
					subject: replace_variables(template.subject), 
					text: replace_variables(template.text),
					email_type_id: apply_created_email_type.id,
					gig_id: id)

					raise "E-Mail konnte nicht erzeugt werden ... subject: #{replace_variables(template.subject)}; text: #{replace_variables(template.text)}; email_type_id: #{apply_created_email_type.id}"
				end

				return true
			elsif apply_created_mails.count == 1
				# E-Mail wurde schon erzeugt, aber noch nicht abgesendet
				return true
			end
		end

		return false
	end

	def replace_variables(text)
		text = text.gsub(/contact-name/, contact.name)
		text = text.gsub(/location-name/, location.festival ? location.name + "-Festival" : location.name)
		text
	end
end
