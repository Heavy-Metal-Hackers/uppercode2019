class Address < ActiveRecord::Base
  # TODO country and fed state as enum
  belongs_to :create_user , class_name: :User
  belongs_to :update_user , class_name: :User
  include PgSearch

  # geocode addresses that miss lat and lng, like user's address
  geocoded_by :full_street_address, :latitude => :lat, :longitude => :lng
  after_validation :geocode, if: ->(obj) {
    obj.street.present? && obj.zip_code.present? &&
        (obj.lat.blank? || obj.lng.blank? || obj.lat == 0.0 && obj.lng == 0.0)
  } # auto-fetch coordinates

  #after_validation do
  #  customer_id = if customer.present? then customer.id else nil end
  #  self.clear_latlng_cache(customer_id)
  #end

  def full_street_address
    if ( street.present? || street_no.present? ) && ( zip_code.present? || city.present? )
    street.to_s + ' ' + street_no.to_s + ', ' + zip_code.to_s + ' ' + city.to_s
    elsif street.present? || street_no.present?
      street.to_s + ' ' + street_no.to_s
    elsif zip_code.present? || city.present?
      zip_code.to_s + ' ' + city.to_s
    else
      ''
    end
  end

  def to_s
    full_street_address
  end

  def set_inactive(user = nil)
    self.active = false
    self.update_user = user
    self.save
  end

  def get_duplicates
    Address.where(street: street, street_no: street_no, zip_code: zip_code, city: city, active: true)
  end

  def google_maps_url
    'http://maps.google.com/maps?z=12&t=m&q=loc:' + lat.to_s + '+' + lng.to_s
  end

  def first_line
    (self.street.to_s + ' ' + self.street_no.to_s + ' ' + self.street_no_addition.to_s).squish
  end

  def second_line
    (self.zip_code.to_s + ' ' + self.city.to_s).squish
  end

  def self.min_bounding_lat
    Rails.cache.fetch("address.min_bounding_lat", :expires_in => 1.hours) do
      Address.geocoded.where(active: true).order(lat: :asc).first.lat.to_f
    end
  end

  def self.max_bounding_lat
    Rails.cache.fetch("address.max_bounding_lat", :expires_in => 1.hours) do
      Address.geocoded.where(active: true).order(lat: :asc).last.lat.to_f
    end
  end

  def self.min_bounding_lng
    Rails.cache.fetch("address.min_bounding_lng", :expires_in => 1.hours) do
      Address.geocoded.where(active: true).order(lng: :asc).first.lng.to_f
    end
  end

  def self.max_bounding_lng
    Rails.cache.fetch("address.max_bounding_lng", :expires_in => 1.hours) do
      Address.geocoded.where(active: true).order(lng: :asc).last.lng.to_f
    end
  end

  def self.bounding_box
    {
        north_east: {
            lat: max_bounding_lat,
            lng: max_bounding_lng
        },
        south_west: {
            lat: min_bounding_lat,
            lng: min_bounding_lng
        }
    }
  end

  def clear_latlng_cache
    Rails.cache.delete("address.min_bounding_lat")
    Rails.cache.delete("address.max_bounding_lat")
    Rails.cache.delete("address.min_bounding_lng")
    Rails.cache.delete("address.max_bounding_lng")
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
    :against => [:street, :street_no, :street_no_addition, :zip_code, :city],
    :using => {
      :tsearch => {:prefix => true},
      :dmetaphone => {},
      :trigram => {}
    },
    :ignoring => :accents
end
