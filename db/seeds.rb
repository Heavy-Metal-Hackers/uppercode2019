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

def parse_categories_xml(oew_type)
  gastronomy_categories_xml = Nokogiri::XML(open("#{Rails.root}/public/ooe_daten/OEW-Kategorien-#{oew_type}.xml"))
  gastronomy_categories_hash = gastronomy_categories_xml.root.to_hash
  parse_categories_data gastronomy_categories_hash
end

oew_types = %w(Gastronomie POIs Touren Unterkuenfte Veranstaltungen)
oew_categories = oew_types.map {|oew_type|
  parse_categories_xml(oew_type).merge({:name => oew_type}) # TODO name at earlier position
}

# puts JSON.pretty_generate oew_categories

File.write("#{Rails.root}/public/ooe_daten/parsed_categories.json", JSON.pretty_generate(oew_categories))

def create_category_records(category_sets)
  category_sets.each do |category_set|
    puts category_set[:Type]
    category_set_record = CategorySet.find_or_create_by(
        category_type: category_set[:type],
        name: category_set[:name], # TODO should not be condition for find
        active: true
    )
    # TODO iterate over children±±
  end
end

create_category_records oew_categories

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
