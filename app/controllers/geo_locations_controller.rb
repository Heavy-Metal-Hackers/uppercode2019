class GeoLocationsController < ApplicationController
  
  def index
    # TODO query param for different types
    @tickets = Ticket.where(active: true).order(stoerungsbeginn: :desc)
    @tickets = @tickets.where('updated_at > ?', Time.zone.parse(params[:last_sync])) unless params[:last_sync].blank? || (Time.zone.parse params[:last_sync] rescue nil) == nil
    # respond_to do |format|
    #   format.html
    #   format.json
    #   format.csv { send_data @tickets.to_csv }
    #   format.xls # { send_data @tickets.to_csv(col_sep: "\t") }
    # end
  end
  
  def deleted
    ticket_ids = Ticket.select(:ticket_no).where(active: false).order(:ticket_no)
    #respond_with ticket_ids
    ticket_ids
  end

  def show
    ticket_no = params[:id]
    @ticket = Ticket.find_by(active: true, ticketnummer: ticket_no)
    if !@ticket.active
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
    @ticket = ticket.new(
        ticket_type: ticket_type,
        description: description,
        state: 'open',
        # product: product, # TODO get default product for given action/controller
        input: params[:ticket][:input],
        is_read: false,
        rating: params[:ticket][:rating],
        error_report: error_report,
        screenshot: screenshot,
        given_by: current_user,
        given_at: DateTime.now,

        url: params[:ticket][:url],
        action: params[:ticket][:action],
        controller: params[:ticket][:controller],

        screen_width: params[:ticket][:platform][:screen][:width],
        screen_height: params[:ticket][:platform][:screen][:height],
        viewport_width: params[:ticket][:platform][:viewport][:width],
        viewport_height: params[:ticket][:platform][:viewport][:height],

        ip: request.remote_ip,
        country: request.location.country,

        device: params[:ticket][:platform][:device] || browser.device.name,
        device_manufacturer: params[:ticket][:platform][:device_manufacturer],
        os: params[:ticket][:platform][:os] || browser.platform.name,
        browser: params[:ticket][:platform][:browser] || browser.name,
        browser_version: params[:ticket][:platform][:browser_version],
        user_agent: params[:ticket][:platform][:user_agent] || request.headers["User-Agent"],

        customer: current_customer,
        create_user: current_user,
        update_user: current_user,
        active: true
    )
  end

  # PATCH/PUT /tickets/1
  # PATCH/PUT /tickets/1.json
  def update
    @ticket.update(ticket_params)

  end

  def destroy
    @ticket.active = false
    @ticket.save
    #NotificationUtils.create_linked_notification(I18n.t('notification_message.ticket.deleted'), @ticket.to_s, current_user, 'MYAVIATE', @ticket)
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def ticket_params
      params.require(:ticket).permit(:ticket_type, :description, :activity_id, :error_report_id, :product_id, :state, :screenshot, :input, :is_read, :result_info, :ticketable_id, :ticketable_type, :given_by_id, :given_at, :customer_id, :active)
    end
end
