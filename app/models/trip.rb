class Trip < ActiveRecord::Base
  belongs_to :guest
  has_one :trip_assistant_instance
  has_many :destinations, class_name: 'TripDestination'
  include PgSearch

  def to_s
    'trip ' + id
  end

  def start_date
    destinations.order(date: :asc).first.date rescue nil
  end

  def end_date
    destinations.sort_by {|destination| destination.end_date}.last.end_date rescue nil
  end

  def destinations_of_date(date)
    destinations.where(active: true).select{|destination| destination.start_date.to_date <= date && destination.end_date.to_date >= date}
  end

  def self.get_suggestion(suggestion_type)
    {
        title: (
          case suggestion_type
            when 'Gastronomy'
              'Restaurant oder Gaststätte'
            when 'Event'
              'Veranstaltungen'
            when 'Tour'
              'Touren'
            when 'Accomodations'
              'Unterkünfte'
            when 'PointOfInterest'
              'Interessante Hotspots'
            else
              ''
          end
        ),
        details: (
          case suggestion_type
            when 'Gastronomy'
              'Plane dein Mittagessen'
            when 'Event'
              'Suche Veranstaltungen in der Nähe'
            when 'Tour'
              'Du hast noch keine Tour geplant'
            when 'Accomodations'
              'Für diesem Tag hast du keine Unterkunft gebucht'
            when 'PointOfInterest'
              'Interessante Hotspots in der Nähe'
            else
              ''
          end
        ),
        link: (
          case suggestion_type
            when 'Gastronomy'
              'https://www.oberoesterreich.at/essen-trinken.html'
            when 'Event'
              'https://www.oberoesterreich.at/aktivitaeten.html'
            when 'Tour'
              'https://www.oberoesterreich.at/aktivitaeten.html'
            when 'Accomodations'
              'https://www.oberoesterreich.at/unterkunft.html'
            when 'PointOfInterest'
              'https://www.oberoesterreich.at/aktivitaeten.html'
            else
              ''
          end
        ),
        type: suggestion_type
    }
  end

  def suggestions_of_date(date)
    types = GeoLocation.subclasses.map{|subclass| subclass.name}
    planned_types = destinations_of_date(date).map{|destination| destination.geo_location.class.name}
    suggested_types = types.reject{|type| planned_types.include? type}

    suggested_types.map{|suggested_type| Trip.get_suggestion suggested_type}
  end

  def set_inactive(user = nil)
    self.active = false
    self.update_user = user
    self.save
  end

  def self.get_all
    paginate(:per_page => 999999999, :page => 1)
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |record|
        csv << record.attributes.values_at(*column_names)
      end
    end
  end

  def self.meta_data?
    false
  end

  def self.search(search, page)
    per_page = 20
    if page == 'all'
      per_page = 999999999
      page = 1
    end
    if search && search != ""
      paginate(:per_page => per_page, :page => page).full_search(search)
    else
      paginate(:per_page => per_page, :page => page)
    end
  end

  pg_search_scope :full_search,
    :against => [],
    :using => {
      :tsearch => {:prefix => true},
      :dmetaphone => {},
      :trigram => {}
    },
    :ignoring => :accents
end
