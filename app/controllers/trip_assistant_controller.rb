class TripAssistantController < ApplicationController
  layout 'fullscreen_application'

  BASE_MAIN_PAGE = 'https://www.oberoesterreich.at/'

  def index
    # TODO get last visited page from trip_assistant_instance, refer it by userId in cookie
    @current_main_page = BASE_MAIN_PAGE
  end

end
