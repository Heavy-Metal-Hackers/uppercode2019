class TripDestinationsController < ApplicationController

  def index
    @trips = Trip.where(active: true).order(starts_at: :desc)
    @trips = @trips.where('updated_at > ?', Time.zone.parse(params[:last_sync])) unless params[:last_sync].blank? || (Time.zone.parse params[:last_sync] rescue nil) == nil
     respond_to do |format|
       format.html
       format.json
    #   format.csv { send_data @tickets.to_csv }
    #   format.xls # { send_data @tickets.to_csv(col_sep: "\t") }
     end
  end
  
  def deleted
    trip_ids = Trip.select(:id).where(active: false).order(:id)
    trip_ids
  end

  def show
    @trip = Trip.find_by(active: true, id: params[:id])
    if !@trip.active
      # TODO return 404
    end
  end

  def card
    @trip_destination = TripDestination.find_by(active: true, id: params[:id])
    render :layout => false
  end

  def new
    # stub
  end

  def edit
    # stub
  end

  def create
    @trip = Trip.new(
        guest: current_guest,
        create_user: current_user,
        update_user: current_user,
        active: true
    )
  end

  def update
    @trip.update(trip_params)

  end

  def destroy
    @trip.active = false
    @trip.save
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def trip_params
      params.require(:trip).permit(:id, :guest_id, :active)
    end
end
