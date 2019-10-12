# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# TODO xml importer for soap calls and example data??
# TODO or just put it here as lists

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

)=end
