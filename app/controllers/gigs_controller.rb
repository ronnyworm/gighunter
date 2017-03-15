class GigsController < ApplicationController
  before_action :set_gig, only: [:show, :edit, :update, :destroy, :duplicate]

  before_action :authenticate_user!

  # GET /gigs
  # GET /gigs.json
  def index
    if params[:archived]
      @gigs = Gig.all.order(:datetime)
    else
      @gigs = []

      Gig.all.order(:datetime).each do |g|
        if g.current_status != "archiviert"
          @gigs << g
        end
      end
    end

    @status_values = StatusValue.all
    @members = current_user.band.user
    @locations = Location.all
  end

  # GET /gigs/1
  # GET /gigs/1.json
  def show
  end

  # GET /gigs/new
  def new
    @gig = Gig.new

    set_contact_and_location
  end

  # GET /gigs/1/edit
  def edit
    set_contact_and_location

    @contacts = Contact.all.map { |e| e.summary }
    @contacts = [@contacts, ""].flatten!

    @locations = Location.all.map { |e| e.name }
    @no_edit_for_contact_and_location = true

    @mails = @gig.email.order(:transferred_at).reverse
    @reminders = @gig.reminder
  end

  def duplicate
    result = "Der Gig wurde kopiert!"

    copy = @gig.dup
    if copy.location.festival
      copy[:name] = (copy.name.to_i + 1).to_s
      copy[:datetime] = copy.datetime + 1.year

      result += " Weil es sich um ein Festival handelt, ist er bei #{copy.location.name} #{copy[:name]} zu finden."
    end


    copy.save

    Status.create(gig_id: copy.id, status_value_id: StatusValue.find_by(text: "unbearbeitet").id)

    redirect_to gigs_path, notice: result
  end

  # POST /gigs
  # POST /gigs.json
  def create
    gig_params = set_attributes

    @gig = Gig.new(gig_params)

    respond_to do |format|
      if @gig.save

        Status.create(gig_id: @gig.id, status_value_id: StatusValue.find_by(text: @status).id)

        format.html { redirect_to edit_gig_path(@gig), notice: I18n.t('models.created') }
        format.json { render :show, status: :created, location: @gig }

        Activity.create(what: "Gig " + (@gig.location ? "#{@gig.location.name} #{@gig.name}" : "#{@gig.name}") + " wurde erstellt",
          url: "/gigs/#{@gig.id}/edit",
          manual: false)
      else
        format.html { render :new }
        format.json { render json: @gig.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /gigs/1
  # PATCH/PUT /gigs/1.json
  def update
    gig_params = set_attributes

    Activity.create(what: "Gig " + (@gig.location ? "#{@gig.location.name} #{@gig.name}" : "#{@gig.name}") + " wurde bearbeitet",
      url: "/gigs/#{@gig.id}/edit",
      manual: false)

    respond_to do |format|
      if @gig.update(gig_params)

        if @gig.current_status != @status
          Status.create(gig_id: @gig.id, status_value_id: StatusValue.find_by(text: @status).id)
        end

        format.html { redirect_to edit_gig_path(@gig), notice: I18n.t('models.updated') }
        format.json { render :show, status: :ok, location: @gig }
      else
        format.html { render :edit }
        format.json { render json: @gig.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gigs/1
  # DELETE /gigs/1.json
  def destroy
    # in Zukunft lieber archivieren!

    Email.where(gig_id: @gig.id).destroy_all
    Status.where(gig_id: @gig.id).destroy_all

    @gig.destroy


    respond_to do |format|
      format.html { redirect_to gigs_url, notice: I18n.t('models.destroyed') }
      format.json { head :no_content }
    end
  end








  def edit_band
    u = User.find(params[:id])

    u[params[:attribute]] = params[:text]
    u.save

    if u.errors.empty?
      redirect_to "/settings"
    else
      redirect_to "settings", alert: "Beim Speichern der Band hat es Fehler gegeben: #{u.errors.full_messages.join("; ")}"
    end
  end

  def locations
    if params[:festivals]
      @locations = Location.all
    else
      @locations = Location.where(festival: false)
    end
    @contacts = Contact.all.map { |e| e.summary }

    @contacts = [@contacts, ""].flatten!
  end

  def edit_location
    l = Location.find(params[:location_id])

    l[:name] = params[:locationname]
    l[:website] = params[:locationwebsite]
    l[:address] = params[:locationaddress]
    l[:festival] = params[:locationisfestival] == "on"

    cl = Contactlocation.find_by(location_id: l.id)
    
    /(?<name>.*) \((?<email>.*)\)/ =~ params[:locationcontact]
    c = Contact.find_by(name: name, email: email)

    if c
      # das kann nur passieren, wenn noch kein Kontakt eingetragen ist und jetzt immer noch nicht
      if cl
        cl[:contact_id] = c.id
        cl.save
      else
        Contactlocation.create(location_id: l.id, contact_id: c.id)
      end
    else
      # Wenn kein Kontakt gefunden wird, aber schon eine contact-location existiert, dann lösche sie
      if cl
        cl.destroy
        logger.debug "destroyed contactlocation"
      end
    end


    if l.save
      redirect_to request.referer, notice: "Die Location wurde geändert."
    else
      redirect_to request.referer, alert: "Die Location konnte nicht gespeichert werden: #{l.errors.full_messages.join("; ")}"
    end
  end

  def post_locations
    l = Location.create(name: params[:name], address: params[:address], festival: params[:festival], website: params[:website])

    if l.errors.empty?
      redirect_to locations_path, notice: "Die Location wurde gespeichert."
    else
      redirect_to locations_path, alert: "Die Location konnte nicht gespeichert werden: #{l.errors.full_messages.join("; ")}"
    end
  end

  def contacts
    @contacts = Contact.all
  end

  def edit_contact
    c = Contact.find(params[:contact_id])

    c[:name] = params[:contactname]
    c[:email] = params[:contactemail]
    c[:telephone] = params[:contactphone]
    c[:info] = params[:contactinfo]

    if c.save
      redirect_to request.referer, notice: "Der Kontakt wurde gespeichert."
    else
      redirect_to request.referer, alert: "Der Kontakt konnte nicht gespeichert werden: #{c.errors.full_messages.join("; ")}"
    end
  end

  def post_contacts
    c = Contact.create(name: params[:name], email: params[:email], telephone: params[:telephone], info: params[:info])

    if c.errors.empty?
      redirect_to contacts_path, notice: "Der Kontakt wurde gespeichert."
    else
      redirect_to contacts_path, alert: "Der Kontakt konnte nicht gespeichert werden: #{c.errors.full_messages.join("; ")}"
    end
  end

  def create_reminder
    r = Reminder.create(text: params[:text], due: params[:due], done: false, gig_id: params[:gig_id])

    if r.errors.empty?
      redirect_to request.referer, notice: "Die Erinnerung wurde gespeichert."
    else
      redirect_to request.referer, alert: "Die Erinnerung konnte nicht gespeichert werden: #{r.errors.full_messages.join("; ")}"
    end
  end

  def settings
    @status_values = StatusValue.all
    t = Email.get_template

    @template_subject = t.subject
    @template_text = t.text

    @members = current_user.band.user
  end

  def edit_status
    sv = StatusValue.find(params[:status_id])

    sv[:text] = params[:statustext]
    sv[:order] = params[:statusorder]

    if sv.save
      redirect_to settings_path, notice: "Der Statuswert wurde gespeichert."
    else
      redirect_to settings_path, alert: "Der Statuswert konnte nicht gespeichert werden: #{sv.errors.full_messages.join("; ")}"
    end
  end

  def post_settings
    sv = StatusValue.create(text: params[:text], order: params[:order])

    if sv.errors.empty?
      redirect_to settings_path, notice: "Der Statuswert wurde hinzugefügt."
    else
      redirect_to settings_path, alert: "Der Statuswert konnte nicht gespeichert werden: #{sv.errors.full_messages.join("; ")}"
    end
  end

  def edit_template
    template = Email.get_template

    template[:subject] = params[:subject]
    template[:text] = params[:text]

    if template.save
      redirect_to settings_path, notice: "Die E-Mail-Vorlage wurde geändert."
    else
      redirect_to settings_path, alert: "Die E-Mail-Vorlage konnte nicht geändert werden: #{template.errors.full_messages.join("; ")}"
    end
  end

  def apply
    @relevant_gigs = []
    @next_relevant_gigs = []
    @relevant_gigs_no_email = []

    Gig.all_that_need_to_be_sent.each do |g|
      if g.datetime < DateTime.now + Rails.configuration.months_until_application.month
        @relevant_gigs.push({ id: g.id, name: "#{g.location.name} #{g.name}", datetime: Rails.date_relative(g.datetime.to_date), raw_datetime: g.datetime, email: g.contact.email })
      else
        @next_relevant_gigs.push({ id: g.id, name: "#{g.location.name} #{g.name}", datetime: Rails.date_relative(g.datetime.to_date), raw_datetime: g.datetime, email: g.contact.email })
      end
    end

    Gig.all_that_need_action_but_not_via_email.each do |g|
      if g.datetime < DateTime.now + Rails.configuration.months_until_application.month
        @relevant_gigs_no_email.push({ id: g.id, name: "#{g.location.name} #{g.name}", datetime: Rails.date_relative(g.datetime.to_date), raw_datetime: g.datetime, info: g.contact.info })
      else
        @next_relevant_gigs.push({ id: g.id, name: "#{g.location.name} #{g.name}", datetime: Rails.date_relative(g.datetime.to_date), raw_datetime: g.datetime, info: g.contact.info })
      end
    end

    @relevant_gigs = @relevant_gigs.sort_by { |x| x[:raw_datetime] }
    @next_relevant_gigs = @next_relevant_gigs.sort_by { |x| x[:raw_datetime] }
    @relevant_gigs_no_email = @relevant_gigs_no_email.sort_by { |x| x[:raw_datetime] }
  end

  def post_apply
    count = 0

    Gig.all_that_need_to_be_sent.each do |g|
      mail = g.get_apply_email

      GigMailer.apply_contact(mail, g.contact.email).deliver
      mail.email_type_id = EmailType.find_by(text: "apply_sent").id
      mail.transferred_at = DateTime.now
      mail.save
      count += 1
    end

    Activity.create(what: "#{count} E-Mails wurden versendet.",
          manual: false)

    redirect_to gigs_path, notice: "#{count} E-Mails wurden versendet."
  end

  def show_mail
    @mail = Email.find_by(gig_id: params[:id], email_type_id: EmailType.find_by(text: "apply_created").id)
    @contact = Gig.find(params[:id]).contact
  end

  def send_single_mail
    mail = Email.find(params[:mail_id].to_i)
    contact = Contact.find(params[:contact_id].to_i)

    GigMailer.apply_contact(mail, contact.email).deliver
    mail.email_type_id = EmailType.find_by(text: "apply_sent").id
    mail.transferred_at = DateTime.now
    mail.save

    the_gig = Gig.find(mail.gig_id)
    name_text = the_gig.location ? "#{the_gig.location.name} #{the_gig.name}" : "#{the_gig.name}"

    Activity.create(what: "Die E-Mail an #{contact.email} zum Gig #{name_text} wurde versendet.",
          manual: false)

    redirect_to gigs_path, notice: "Die E-Mail an #{contact.email} wurde versendet."
  end

  def create_email
    transferred = nil
    email = Email.new

    if not params[:transferred_at] or params[:transferred_at].blank?
      transferred = DateTime.now
    else
      begin
        transferred = DateTime.parse(params[:transferred_at])
      rescue Exception => e
        email.errors.add(:transferred_at, "Das Datum muss im Format JJJJ-MM-TT angegeben werden!")
        redirect_to request.referer, alert: "Die E-Mail / Nachricht konnte nicht gespeichert werden: #{email.errors.full_messages.join("; ")}"
        return
      end
    end

    email = Email.create(text: params[:text], subject: params[:subject], gig_id: params[:gig_id], email_type_id: params[:email_type_id], transferred_at: transferred)

    if email.errors.empty?
      redirect_to request.referer, notice: "Die E-Mail / Nachricht wurde gespeichert."

      the_gig = Gig.find(params[:gig_id])
      name_text = the_gig.location ? "#{the_gig.location.name} #{the_gig.name}" : "#{the_gig.name}"

      Activity.create(what: "Eine E-Mail / Nachricht zum Gig #{name_text} wurde gespeichert.",
          url: "/gigs/#{the_gig.id}/edit",
          manual: false)
    else
      redirect_to request.referer, alert: "Die E-Mail / Nachricht konnte nicht gespeichert werden: #{email.errors.full_messages.join("; ")}"
    end
  end

  def edit_mail
    email = Email.find(params[:email_id])

    if not email
      email.errors.add(:id, "Die Nachricht konnte nicht gefunden werden!")
      redirect_to request.referer, alert: "Die E-Mail / Nachricht konnte nicht gespeichert werden: #{email.errors.full_messages.join("; ")}"
      return
    end

    transferred = nil

    if params[:transferred_at] and not params[:transferred_at].empty?
      begin
        transferred = DateTime.parse(params[:transferred_at])
      rescue Exception => e
        email.errors.add(:transferred_at, "Das Datum muss im Format JJJJ-MM-TT angegeben werden!")
        redirect_to request.referer, alert: "Die E-Mail / Nachricht konnte nicht gespeichert werden: #{email.errors.full_messages.join("; ")}"
        return
      end

      email[:transferred_at] = params[:transferred_at]
    end
    
    email[:subject] = params[:subject]
    email[:text] = params[:text]

    email.save

    if email.errors.empty?
      redirect_to request.referer, notice: "Die E-Mail / Nachricht wurde gespeichert."
    else
      redirect_to request.referer, alert: "Die E-Mail / Nachricht konnte nicht gespeichert werden: #{email.errors.full_messages.join("; ")}"
    end
  end

  def recreate_mail
    @mail = Email.find(params[:id])
    gig = Gig.find(@mail.gig_id)
    @mail.destroy

    gig.get_apply_email

    redirect_to request.referer, notice: "Die E-Mail-Vorlage wurde neu erstellt."
  end

  def remove_mail
    @mail = Email.find(params[:id])
    @mail.destroy

    redirect_to request.referer, notice: "Die E-Mail / Nachricht wurde gelöscht."
  end

  def activities
    @activities = Activity.order(:created_at).reverse
  end

  def post_activities
    a = Activity.create(what: params[:what], url: params[:url], manual: true)

    if a.errors.empty?
      redirect_to activities_path, notice: "Die Aktivität wurde gespeichert."
    else
      redirect_to activities_path, alert: "Die Aktivität konnte nicht gespeichert werden: #{a.errors.full_messages.join("; ")}"
    end
  end








  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gig
      @gig = Gig.find(params[:id])
    end

    def set_contact_and_location
      @status = @gig.current_status

      if @gig.location
        params[:locationid] = @gig.location.id
        params[:locationname] = @gig.location.name
        params[:locationisfestival] = @gig.location.festival
        params[:locationaddress] = @gig.location.address
        params[:locationwebsite] = @gig.location.website
      end

      if @gig.contact
        params[:contactid] = @gig.contact.id
        params[:contactname] = @gig.contact.name
        params[:contactemail] = @gig.contact.email
        params[:contactphone] = @gig.contact.telephone
        params[:contactinfo] = @gig.contact.info
      end
    end

    def set_attributes
      unless params[:gig]
        raise "Wir brauchen params[:gig]!"
      end

      name = params[:gig][:name]
      datetime = params[:gig][:datetimereadable]
      if datetime !~ /(\d\d\d\d-\d\d-\d\d \d\d:\d\d)|(\d\d\d\d-\d\d-\d\d)/
        datetime = nil
      end

      if datetime
        datetime = ActiveSupport::TimeZone[Rails.application.config.time_zone].parse(datetime)    
      else
        
      end
      vorhandenes_equipment = params[:gig][:vorhandenes_equipment]
      link_forum = params[:gig][:link_forum]
      user_id = User.find_by(name: params[:gig][:user]).id
      @status = params[:gig][:status]

      # contact
      contactname = params[:contactname]

      contact = Contact.find_by(name: contactname)

      if not contact
        create_new_contact = true
      else
        if params[:contactemail] and not params[:contactemail].empty?
          if contact.email != params[:contactemail]
            create_new_contact = true
          end
        end

        if params[:contactphone] and not params[:contactphone].empty?
          if contact.telephone != params[:contactphone]
            create_new_contact = true
          end
        end

        if params[:contactinfo] and not params[:contactinfo].empty?
          if contact.info != params[:contactinfo]
            create_new_contact = true
          end
        end
      end

      if create_new_contact
        contact = Contact.create(name: contactname, email: params[:contactemail], telephone: params[:contactphone], info: params[:contactinfo])
      end

      # location
      locationname = params[:locationname]
      location = Location.find_by(name: locationname)
      if not location
        location = Location.create(name: locationname, address: params[:locationaddress], website: params[:locationwebsite], festival: params[:locationisfestival])

        Contactlocation.create(location_id: location.id, contact_id: contact.id)
      elsif not Contactlocation.find_by(location_id: location.id, contact_id: contact.id)
        Contactlocation.create(location_id: location.id, contact_id: contact.id)
      end

      {
        name: name,
        datetime: datetime,
        vorhandenes_equipment: vorhandenes_equipment,
        link_forum: link_forum,
        user_id: user_id,
        location_id: location.id
      }
    end
end
