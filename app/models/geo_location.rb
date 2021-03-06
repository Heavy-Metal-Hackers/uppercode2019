class GeoLocation < ActiveRecord::Base
  belongs_to :address
  belongs_to :contact_address, class_name: 'Address'
  has_and_belongs_to_many :categories

  include PgSearch

  def to_s
    address.to_s
  end

  def link_scope
    ''
  end

  def formatted_polygon
    return if polygon.blank?
    polygon.split.select.with_index{|_,i| (i) % 2 == 0}.zip(polygon.split.select.with_index{|_,i| (i+1) % 2 == 0})
        .map{|record| [record[0].to_f, record[1].to_f]}
  end

  def link
    "https://www.oberoesterreich.at/oesterreich-#{link_scope}/detail/#{local_id}"
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
    :against => [:name],
    :using => {
      :tsearch => {:prefix => true},
      :dmetaphone => {},
      :trigram => {}
    },
    :ignoring => :accents
end
