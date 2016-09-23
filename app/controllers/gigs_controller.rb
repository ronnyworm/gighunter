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
  end

  # GET /gigs/1/edit
  def edit
  end

  # POST /gigs
  # POST /gigs.json
  def create

    @gig = Gig.new(name: params[:name], user_id: User.find_by(name: params[:responsible]), location_id: Location.find_by(name: params[:location_id]).id)

    datetime = params[:datetime]
    if datetime !~ /\d\d\d\d-\d\d-\d\d \d\d:\d\d/ and datetime !~ /\d\d\d\d-\d\d-\d\d/
      @gig.errors.add(:datetime, " hat das falsche Format!")
      render :new
      return
    end

    @gig[:datetime] = ActiveSupport::TimeZone[Rails.application.config.time_zone].parse(datetime)



    respond_to do |format|
      if @gig.save


        Status.create(gig_id: @gig.id, status_value_id: StatusValue.find_by(text: params[:status_value]).id)

        format.html { redirect_to @gig, notice: I18n.t('models.created') }
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
    respond_to do |format|
      if @gig.update(gig_params)
        format.html { redirect_to @gig, notice: I18n.t('models.updated') }
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
    @locations = current_user.band.location
  end

  def post_locations
    Location.create(band_id: current_user.band.id, name: params[:name], address: params[:address], festival: params[:festival], website: params[:website])

    redirect_to locations_path, notice: "Die Location wurde gespeichert."
  end

  def contacts
    @contacts = current_user.band.contact
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
end
