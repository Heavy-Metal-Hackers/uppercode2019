json.id @trip.id
json.guest @trip.guest

json.destinations(@trip.destinations) do |destination|
  json.id destination.id
  json.geo_location destination.geo_location
  json.start_date destination.start_date
  json.end_date destination.end_date
  json.duration destination.duration
  json.active destination.active
end

json.active @trip.active