class TravellerProfilesController < ApplicationController

  def index
    @traveller_profiles = TravellerProfile.where(active: true).order(starts_at: :desc)
    @traveller_profiles = @traveller_profiles.where('updated_at > ?', Time.zone.parse(params[:last_sync])) unless params[:last_sync].blank? || (Time.zone.parse params[:last_sync] rescue nil) == nil
    # respond_to do |format|
    #   format.html
    #   format.json
    #   format.csv { send_data @tickets.to_csv }
    #   format.xls # { send_data @tickets.to_csv(col_sep: "\t") }
    # end
  end
  
  def deleted
    traveller_profile_ids = TravellerProfile.select(:id).where(active: false).order(:id)
    traveller_profile_ids
  end

  def show
    @traveller_profile = TravellerProfile.find_by(active: true, id: params[:id])
    if !@traveller_profile.active
      # TODO return 404
    end
  end

  def new
    # stub
  end

  def edit
    # stub
  end

  def create
    @traveller_profile = TravellerProfile.new(
        customer: current_customer,
        create_user: current_user,
        update_user: current_user,
        active: true
    )
  end

  def update
    @traveller_profile.update(traveller_profile_params)

  end

  def destroy
    @traveller_profile.active = false
    @traveller_profile.save
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def traveller_profile_params
      params.require(:traveller_profile).permit(:id, :customer_id, :active)
    end
end
