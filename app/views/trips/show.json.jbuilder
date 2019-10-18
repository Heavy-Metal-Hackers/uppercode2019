json.id @trip.id
json.guest @trip.guest

json.destinations(@trip.destinations) do |destination|
  json.id destination.id
  #json.geo_location destination.geo_location

  json.geo_location do
    json.id destination.geo_location.id
    json.address destination.geo_location.address
    json.contact_address destination.geo_location.contact_address
    json.categories destination.geo_location.categories
    json.type destination.geo_location.type
    json.link destination.geo_location.link
    json.description destination.geo_location.description
    json.short_description destination.geo_location.short_description
    json.name destination.geo_location.name
    json.keywords destination.geo_location.keywords
    json.image destination.geo_location.image
    json.polygon destination.geo_location.formatted_polygon
    json.difficulty destination.geo_location.difficulty
    json.duration destination.geo_location.duration
    json.length destination.geo_location.length
    json.altitude_difference destination.geo_location.altitude_difference
    json.round_tour destination.geo_location.round_tour
    json.rest_stop destination.geo_location.rest_stop
    json.elev_min destination.geo_location.elev_min
    json.elev_max destination.geo_location.elev_max
    json.elev_image destination.geo_location.elev_image
    json.gpx_link destination.geo_location.gpx_link
    json.family_friendly destination.geo_location.family_friendly
    json.barrier_free_info destination.geo_location.barrier_free_info
    json.tel destination.geo_location.tel
    json.email destination.geo_location.email
    json.contact_email destination.geo_location.contact_email
    json.contact_link destination.geo_location.contact_link
    json.active destination.active
  end

  json.start_date destination.start_date
  json.end_date destination.end_date
  json.duration destination.duration
  json.active destination.active
end

json.active @trip.active