class Category < ActiveRecord::Base
  belongs_to :parent_category, class_name: 'Category'
  belongs_to :category_set
  has_many :sub_categories, class_name: 'Category'

  include PgSearch

  validates_uniqueness_of :key

  # fields:
  # id,
  # name,
  # pin (optional),
  # schemaorg (optional)
  # TODO name must be retrieved via i18n

  def to_s
    name.to_s
  end

  def main_category_set
    category_set if category_set.present?
    parent_category.main_category_set if parent_category.present?
  end

  def category_type
    category_set.category_type
  end

  def level
    # check how many parent_categories exist, starting at 1 (= has no parent)
    return 1 if parent_company.blank?
    parent_company.level + 1
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
