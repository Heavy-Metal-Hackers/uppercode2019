# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# ========================================
# ======== categories xml parser =========
# ========================================

def parse_attributes(attributes)
  attributes.each_with_object({}) do |attribute, hash|
    hash[attribute[:name].downcase.to_sym] = attribute[:content]
  end
end

def parse_children(children)
  {:children => children.blank? ? [] : children
      .select {|child| child[:type] == :element && child[:name] == 'Category'}
      .map {|child| parse_categories_data(child)}
      .select {|child| child.present?}}
end

def parse_categories_data(hash)
  return if hash.blank?
  return unless %w(Categories Category).include? hash[:name]

  {:_type => hash[:name]}
      .merge(parse_attributes hash[:attributes])
      .merge (parse_children hash[:children])
end

def create_category_records(category_sets)
  category_sets.each do |category_set|
    puts category_set[:Type]
    category_set_record = CategorySet.find_or_create_by(
        category_type: category_set[:type],
        name: category_set[:name], # TODO should not be condition for find
        active: true
    )

    category_set[:children].each do |category|
      category_record = create_category_record category
      category_record.update category_set: category_set_record
    end
  end
end

def create_category_record(category)
  category_record = Category.find_or_create_by(
      key: category[:name], # TODO replace spaces with underscores etc
      name: category[:name],
      pin: category[:pin],
      schemaorg_id: category[:schemaorg],
      active: true
  )

  category[:children].each do |category|
    child_category_record = create_category_record category
    child_category_record.update parent_category: category_record
  end
  category_record
end

def parse_categories_xml(oew_type)
  categories_xml = Nokogiri::XML(open("#{Rails.root}/public/ooe_daten/OEW-Kategorien-#{oew_type}.xml"))
  categories_hash = categories_xml.root.to_hash
  parse_categories_data categories_hash
end

oew_types = %w(Gastronomie POIs Touren Unterkuenfte Veranstaltungen)

#oew_categories = oew_types.map {|oew_type|
#  parse_categories_xml(oew_type).merge({:name => oew_type}) # TODO name at earlier position
#}

# File.write("#{Rails.root}/public/ooe_daten/parsed_categories.json", JSON.pretty_generate(oew_categories))

# create_category_records oew_categories

class Feedjira::Parser::RSSEntry
  element "geo:lat", as: :latitude
  element "geo:long", as: :longitude
  element "link", as: :link
  element "description", as: :description
  element "shortdescription", as: :short_description
  #element "category", as: :category
  element "ec:name", as: :name
  element "ec:street", as: :street
  element "ec:plz", as: :plz
  element "ec:city", as: :city
  element "ec:county", as: :county
  element "ec:country", as: :country
  element "ec:keywords", as: :keywords
  element "ec:maincategory", as: :main_category

  # for toures
  element "georss:polygon", as: :polygon
  element "ec:difficulty", as: :difficulty
  element "ec:length", as: :length
  element "ec:duration", as: :duration
  element "ec:alt_diff", as: :altitude_difference
  element "ec:round_tour", as: :round_tour
  element "ec:rest_stop", as: :rest_stop
  element "ec:elev_min", as: :elev_min
  element "ec:elev_max", as: :elev_max
  element "ec:link", as: :gpx_link
  element "ec:elev_image", as: :elev_image

  # for hotels and POIs
  element "family_friendly", as: :family_friendly
  element "barrier_free_info", as: :barrier_free_info

  # contact info
  element "ec:tel", as: :tel
  element "ec:email", as: :email
  element "ec:contact_name", as: :contact_name
  element "ec:contact_street", as: :contact_street
  element "ec:contact_city", as: :contact_city
  element "ec:contact_plz", as: :contact_plz
  element "ec:contact_email", as: :contact_email
  element "ec:contact_link", as: :contact_link
end

def get_inherited_class_name(main_category)
  case main_category
    when 'Gastro'
      'Gastronomy'
    when 'POI'
      'PointOfInterest'
    when 'Routen'
      'Tour'
    when 'Gastgeber'
      'Accommodation'
    when 'Events'
      'Event'
    else
      main_category
  end
end

def create_geo_entry(feed_entry)
  address_record = Address.find_or_create_by(
      street: (feed_entry.street.sub(feed_entry.street.split.last, '').strip rescue nil),
      street_no: (feed_entry.street.split.last rescue nil),
      zip_code: feed_entry.plz,
      city: feed_entry.city,
      lat: feed_entry.latitude,
      lng: feed_entry.longitude,
      active: true
  )

  contact_address_record = Address.find_or_create_by(
      street: (feed_entry.contact_street.sub(feed_entry.contact_street.split.last, '').strip rescue nil),
      street_no: (feed_entry.contact_street.split.last rescue nil),
      zip_code: feed_entry.contact_plz,
      city: feed_entry.contact_city,
      active: true
  )

  geo_location_record = GeoLocation.find_or_create_by(
      geo_id: feed_entry.id,
      type: get_inherited_class_name(feed_entry.main_category),
      active: true
  )

  geo_location_record.update(
      address: address_record,
      contact_address: contact_address_record,

      link: feed_entry.link,
      description: feed_entry.description,
      short_description: feed_entry.short_description,
      name: feed_entry.name,
      keywords: feed_entry.keywords,
      image: feed_entry.image,

      polygon: feed_entry.polygon,
      difficulty: feed_entry.difficulty,
      length: feed_entry.length,
      duration: feed_entry.duration,
      altitude_difference: feed_entry.altitude_difference,
      round_tour: feed_entry.round_tour,
      rest_stop: feed_entry.rest_stop,
      elev_min: feed_entry.elev_min,
      elev_max: feed_entry.elev_max,
      elev_image: feed_entry.elev_image,
      gpx_link: feed_entry.gpx_link,

      family_friendly: feed_entry.family_friendly,
      barrier_free_info: feed_entry.barrier_free_info,

      tel: feed_entry.tel,
      email: feed_entry.email,
      contact_email: feed_entry.contact_email,
      contact_link: feed_entry.contact_link,

      active: true
  )

end

def parse_georss(oew_type)
  count = 0

  georss = File.read("#{Rails.root}/public/ooe_daten/OEW-#{oew_type}.xml")
  feed = Feedjira.parse(georss)

  #puts feed.entries.first.id
  #puts feed.entries.first.title
  #puts feed.entries.first.link
  #puts feed.entries.first.description
  #puts feed.entries.first.short_description
  #puts feed.entries.first.categories
  # TODO link to given category. Just need first one per entry because other ones are already linked
  #puts feed.entries.first.image
  #puts feed.entries.first.inspect
  #feed.entries.first.keywords.gsub(/\s+/m, ' ').strip.split(' ').each do |keyword|
  #    puts keyword
  #end
  # categories?
  #puts feed.entries.first.latitude
  #puts feed.entries.first.longitude



  feed.entries.each do |entry|
    create_geo_entry entry
    count = count + 1
  end

  puts "#{count} entries for #{oew_type}"
end

oew_types.each {|oew_type| parse_georss(oew_type)}



=begin
customer = Customer.create(
    ccb_Nummer: 7340303520,
    serviceLevel: 'LVR SL Classic SK4',
    kundenklasse: 'A1',
    name: 'Müller Hosting KG',
    active: true
)

contact_person = ContactPerson.create(
    #customer: customer,
    name: 'Wolfgang Schmidt',
    email: 'privat@christian-konrad.me',
    phone: '0176 84172089',
    active: true
)

customer.update(
    standardAnsprechpartner: contact_person
)

Ticket.create(
    ticketnummer: 'TA0000013158672',
    status: 'geschlossen',
    zielzeit: '2018-10-18T12:39',
    dienstTechnik: 'Daten IP',
    dienstProdukt: 'Company Net',
    problembeschreibung: 'Verbindungsaufbau',
    problemtyp: 'kundenreklamation',
    schweregrad: 'minor',
    prio: 4,
    stoerungsbeginn: '2018-10-16T11:28',
    stoerungsende: '2018-10-17T15:13',
    proaktiv: false,
    webIF: true,
    loesungWas: 'Lösung durch Kunde',
    verursacher: 'kunde',
    customer: customer,
    active: true
)
=end
