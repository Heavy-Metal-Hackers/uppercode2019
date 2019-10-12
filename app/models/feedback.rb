class Feedback < ActiveRecord::Base
  enum feedback_type: { error_report: 0, feature_request: 1, help_request: 2, satisfaction_report: 3 }
  enum state: { open: 0, solved: 1, ignored: 2 }
  enum rating: { very_negative: 0, negative: 1, neutral: 2, positive: 3, very_positive: 4 }
  belongs_to :activity
  belongs_to :error_report
  belongs_to :given_by, class_name: :User
  belongs_to :feedbackable, polymorphic: true
  belongs_to :product
  belongs_to :customer
  belongs_to :archived_by, class_name: :User
  belongs_to :create_user, class_name: :User
  belongs_to :update_user, class_name: :User
  has_many :comments, as: :commentable
  include PgSearch

  if ENV.key?('LOCAL_DEPLOYMENT') && ENV['LOCAL_DEPLOYMENT'] == 'true' # Just for local deployment
    has_attached_file :screenshot, # Just for local deployment
                      styles: {
                          card: "380x380>",
                          thumb: "128x128>",
                          icon: "48x48>"
                      },
                      storage: :filesystem,
                      url: "http://localhost:3000/images/:class/:id/:style/:basename.:extension",
                      path: ":rails_root/public/images/:class/:id/:style/:basename.:extension"
  else # Just for local deployment
    has_attached_file :screenshot,
                      styles: {
                          card: "380x380>",
                          thumb: "128x128>",
                          icon: "48x48>"
                      },
                      convert_options: {
                          thumb: "-strip"
                      },
                      path: "/feedback_screenshots/:hash.:style.:extension",
                      hash_secret: "um cavalo morto é um animal sem vida, um cavalo morto é um animal sem vida!",
                      storage: :s3,
                      :s3_protocol => :https,
                      s3_credentials: S3_CREDENTIALS
  end

  validates_attachment :screenshot, :content_type => {:content_type => /\Aimage/}, :size => {:in => 0..3.megabytes}

  def to_s
    "#{given_by} #{feedback_type} '#{feedbackable}' at #{given_at}"
  end

  def formatted_id
    if id.blank?
      ''
    else
      id.to_s.rjust(10, '0')
    end
  end

  def device_full_name
    if device_manufacturer.present?
      "#{device_manufacturer} #{device}"
    else
      device
    end
  end

  def device_type
    browser = Browser.new(user_agent)
    if browser.device.tablet?
      'tablet'
    elsif browser.device.mobile?
      'phone'
    elsif browser.device.tv?
      'tv'
    elsif browser.device.console?
      'console'
    else
      'desktop'
    end
  end

  def browser_icon
    browser = Browser.new(user_agent)
    browser_name = if browser.chrome?
                     'chrome'
                   elsif browser.edge?
                     'edge'
                   elsif browser.firefox?
                     'firefox'
                   elsif browser.ie?
                     'ie'
                   elsif browser.opera?
                     'opera'
                   elsif browser.safari?
                     'safari'
                   else
                     'generic'
                   end
    ActionController::Base.helpers.image_path("icons/browsers/#{browser_name}.svg")
  end

  def os_icon
    browser = Browser.new(user_agent)
    os_name = if browser.platform.android?
                'android'
              elsif browser.platform.blackberry?
                'blackberry'
              elsif browser.platform.chrome_os?
                'chrome'
              elsif browser.platform.firefox_os?
                'firefox'
              elsif browser.platform.ios? ||
                  browser.platform.ios_app?
                'ios'
              elsif browser.platform.linux?
                'linux'
              elsif browser.platform.mac?
                'mac'
              elsif browser.platform.windows? ||
                  browser.platform.windows_mobile? ||
                  browser.platform.windows_phone?
                'windows'
              end
    ActionController::Base.helpers.image_path("icons/os/#{os_name}.svg")
  end

  def device_icon
    ActionController::Base.helpers.image_path("icons/devices/#{device_type}.svg")
  end

  def rating_icon
    icon_name = if self.very_negative?
                  'angry'
                elsif self.negative?
                  'sad'
                elsif self.neutral?
                  'neutral'
                elsif self.positive?
                  'happy'
                elsif self.very_positive?
                  'in-love'
                else
                  'undefined'
                end
    ActionController::Base.helpers.image_path("icons/emojis/#{icon_name}.png")
  end

  def feedback_type_icon
    icon_name = if feedback_type.present?
                  feedback_type
                else
                  'undefined'
                end
    ActionController::Base.helpers.image_path("icons/feedback_type/#{feedback_type}.png")
  end

  def given_by_name
    if given_by.present?
      given_by.name
    else
      'System'
    end
  end

  def given_by_avatar_path
    if given_by.present?
      given_by.avatar_path
    else
      ActionController::Base.helpers.image_path('avatar_circle_blue_512dp.png')
    end
  end

  def set_inactive(user = nil)
    self.active = false
    self.update_user = user
    self.save
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |record|
        csv << record.attributes.values_at(*column_names)
      end
    end
  end

  def self.create_feedback(user, type = :error_report, description = nil, record = nil, input = nil, activity = nil)
    Feedback.create(
               feedback_type: type,
               given_by: user,
               feedbackable: record,
               given_at: DateTime.now,
               input: input,
               description: description,
               activity: activity,
               active: true
    )
  end

  def self.meta_data?
    true
  end

  def self.search(search, page, per_page = 500)
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
                  :against => [:feedback_type, :given_at],
                  :associated_against => {
                      given_by: [:login]
                  },
                  :using => {
                      :tsearch => {:prefix => true},
                      :dmetaphone => {},
                      :trigram => {}
                  },
                  :ignoring => :accents
end
