module UrlUtils

  def self.canonical(url)
    canonical_url = URI.parse(url)
    canonical_url.query = ''
    canonical_url.to_s.gsub('?', '').gsub('/de/', '/')
  end

end