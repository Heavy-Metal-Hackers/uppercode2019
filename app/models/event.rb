class Event < GeoLocation

  def link
    "https://www.oberoesterreich.at/oesterreich-veranstaltung/detail/#{local_id}"
  end

end
