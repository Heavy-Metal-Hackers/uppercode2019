class Guest < ActiveRecord::Base
  has_many :trip_assistant_instances
  has_many :trips
  has_many :chats
  include PgSearch

  def to_s
    name
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
