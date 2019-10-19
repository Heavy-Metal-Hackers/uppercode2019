class TripDestination < ActiveRecord::Base
  belongs_to :trip
  belongs_to :geo_location
  has_one :guest, through: :trip
  include PgSearch

  # TODO has a single marker and a datetime

  def to_s
    # TODO
    'trip_destination ' + id
  end

  # TODO get weather

  def start_date
    date
  end

  # minutes
  def duration
    return 0 if geo_location.is_a? Accommodation
    return 180 if geo_location.duration.blank? # TODO get from google
    geo_location.duration
  end

  def end_date
    return planned_end_date unless planned_end_date.blank?
    date + duration.minutes
  end

  def week_day
    date.strftime('%A')
  end

  # TODO in production, use real weather api
  def random_weather_pick
    Rails.cache.fetch("random_weather_pick.#{id}", :expires_in => 10.minutes) do
      rand(1..5)
    end
  end

  # TODO in production, use real weather api
  def day_temperature
    rand(14..25) - random_weather_pick
  end

  # TODO in production, use real weather api
  def night_temperature
    rand(6..13) - random_weather_pick
  end

  # TODO in production, use real weather api
  def weather_type
    %w(sunny sunny partly_cloudy rain_s_cloudy rain thunderstorms)[random_weather_pick]
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
