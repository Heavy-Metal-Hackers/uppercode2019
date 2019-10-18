class GeoLocationsController < ApplicationController

  def index
    # TODO different query params for search queries
    @geo_locations = GeoLocation.where(type: params[:type], active: true).order(local_id: :desc)
    @geo_locations = @geo_locations.where('updated_at > ?', Time.zone.parse(params[:last_sync])) unless params[:last_sync].blank? || (Time.zone.parse params[:last_sync] rescue nil) == nil
    # respond_to do |format|
    #   format.html
    #   format.json
    #   format.csv { send_data @tickets.to_csv }
    #   format.xls # { send_data @tickets.to_csv(col_sep: "\t") }
    # end
  end

  def around
    # returns all locations in radius of 10km
  end
  
  def deleted
    geo_location_ids = GeoLocation.select(:id).where(active: false).order(:id)
    #respond_with geo_location_ids
    geo_location_ids
  end

  def show
    @geo_location = GeoLocation.find_by(active: true, local_id: params[:local_id])
    if !@geo_location.active
      # TODO return
    end

  end

  def new
    # stub
  end

  def edit
    # stub
  end

  def create
    #
  end

  def update
    #
  end

  def destroy
    @geo_location.active = false
    @geo_location.save
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def geo_location_params
      params.require(:geo_location).permit(:active) # TODO params
    end
end
