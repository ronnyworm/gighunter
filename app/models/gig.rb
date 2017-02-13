class Gig < ActiveRecord::Base
	belongs_to :user
	has_many :status
	has_many :email
	has_many :reminder
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

	def last_message
		if email and not email.empty?
			Rails.datetime_relative(email.order(:transferred_at).reverse.first.transferred_at)
		else
			nil
		end
	end

	def get_apply_email
		# es wird nil zurückgegeben, wenn für diesen Gig keine Bewerbung mehr abgeschickt werden muss

		apply_created_email_type = EmailType.find_by(text: "apply_created")
		apply_sent_email_type = EmailType.find_by(text: "apply_sent")
		manually_entered_type = EmailType.find_by(text: "manually_entered")
		raise "rake db:seed!" unless apply_created_email_type


		if location and contact
			return nil if gibt_es_schon_eine_abgesendete_bewerbungs_mail?

			template = Email.get_template
			apply_created_mails = Email.where(gig_id: id, email_type_id: apply_created_email_type.id)
			manually_entered_mails = Email.where(gig_id: id, email_type_id: manually_entered_type.id).order(:transferred_at)

			if apply_created_mails.count == 0
				if manually_entered_mails.count == 0

					# E-Mail erzeugen
					mail = Email.create(
						subject: replace_variables(template.subject), 
						text: replace_variables(template.text),
						email_type_id: apply_created_email_type.id,
						gig_id: id)

					unless mail
						raise "E-Mail konnte nicht erzeugt werden ... subject: #{replace_variables(template.subject)}; text: #{replace_variables(template.text)}; email_type_id: #{apply_created_email_type.id}"
					end

					return mail
				else
					# wenn es nur eine manuelle E-Mail gibt und sie schon übertragen wurde, passt alles
					if manually_entered_mails.count == 1
						if manually_entered_mails.first.transferred_at
							return nil
						else
							return manually_entered_mails.first
						end
					else
						# keine Unterscheidung an dieser Stelle. Wird schon passen, wenn mehr als eine manuelle E-Mail da ist
						return nil
					end
				end
			elsif apply_created_mails.count == 1
				# E-Mail wurde schon erzeugt
				m = apply_created_mails.first
				if m.transferred_at
					# falsch gekennzeichnet - wurde ja schon versendet
					m[:email_type_id] = apply_sent_email_type.id
					m.save

					return nil
				else
					return m
				end
			end
		end

		return nil
	end

	def gibt_es_schon_eine_abgesendete_bewerbungs_mail?
		apply_sent_email_type = EmailType.find_by(text: "apply_sent")

		return Email.where(gig_id: id, email_type_id: apply_sent_email_type.id).count > 0
	end

	def replace_variables(text)
		text = text.gsub(/\$contact-name\$/, contact.name)
		text = text.gsub(/\$location-name\$/, location.festival ? location.name + "-Festival" : location.name)
		text = text.gsub(/\$responsible\$/, User.find_by(id: user_id).name)
		text = text.gsub(/\$year\$/, datetime.year.to_s)
		text
	end

	def class_by_status
		if current_status == "kontaktiert"
			"kontaktaufgenommen"
		else
			""
		end
	end









	# class methods
	def self.all_that_need_to_be_sent
		result = []

		all.each do |g|
			next if g.current_status == "archiviert"

			mail = g.get_apply_email
			if mail
				c = g.contact
				if c and not c.email.empty? and c.email.include? "@"
					result << g
				end
			end
		end

		result
	end

	def self.all_that_need_action_but_not_via_email
		result = []

		all.each do |g|
			next if g.current_status == "archiviert"

			mail = g.get_apply_email
			if mail
				c = g.contact
				if c.email.empty? or not c.email.include? "@"
					result << g
				end
			end
		end

		result
	end
end
