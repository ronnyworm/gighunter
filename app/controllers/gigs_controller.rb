class GigsController < ApplicationController
  before_action :set_gig, only: [:show, :edit, :update, :destroy]

  before_action :authenticate_user!

  # GET /gigs
  # GET /gigs.json
  def index
    # hier muss noch korrigiert werden, dass nur die Gigs der aktuellen Band angezeigt werden
    @gigs = Gig.all
    @status_values = current_user.band.status_value
    @members = current_user.band.user
    @locations = current_user.band.location
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
    @gig.destroy
    respond_to do |format|
      format.html { redirect_to gigs_url, notice: I18n.t('models.destroyed') }
      format.json { head :no_content }
    end
  end








  def band
    @members = current_user.band.user
  end

  def locations
    @locations = Location.all
  end

  def post_locations
    Location.create(band_id: current_user.band.id, name: params[:name], address: params[:address], festival: params[:festival], website: params[:website])

    redirect_to locations_path, notice: "Die Location wurde gespeichert."
  end

  def contacts
    @contacts = Contact.all
  end

  def post_contacts
    Contact.create(band_id: current_user.band.id, name: params[:name], email: params[:email], telephone: params[:telephone], info: params[:info])

    redirect_to contacts_path, notice: "Der Kontakt wurde gespeichert."
  end

  def settings
    @status_values = current_user.band.status_value
  end

  def post_settings
    StatusValue.create(band_id: current_user.band.id, text: params[:text], order: params[:order])

    redirect_to settings_path, notice: "Die Einstellungen wurden geändert."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gig
      @gig = Gig.find(params[:id])
    end

    def set_contact_and_location
      @status = @gig.current_status

      if @gig.location
        params[:locationname] = @gig.location.name
        params[:locationisfestival] = @gig.location.festival
        params[:locationaddress] = @gig.location.address
        params[:locationwebsite] = @gig.location.website
      end

      if @gig.contact
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

      datetime = ActiveSupport::TimeZone[Rails.application.config.time_zone].parse(datetime)    
      vorhandenes_equipment = params[:gig][:vorhandenes_equipment]
      stagesize = params[:gig][:stagesize]
      link_forum = params[:gig][:link_forum]
      user_id = User.find_by(name: params[:gig][:user]).id
      @status = params[:gig][:status]

      # contact
      contactname = params[:contactname]
      contact = Contact.find_by(name: contactname)
      unless contact
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
        stagesize: stagesize,
        link_forum: link_forum,
        user_id: user_id,
        location_id: location.id
      }
    end
end
