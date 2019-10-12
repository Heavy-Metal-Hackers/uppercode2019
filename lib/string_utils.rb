module StringUtils

  def self.escape_username(string)
    string.gsub(/::/, '/').
        gsub(/[^0-9A-Za-z\-_]/, ''). # replace special chars
        gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
        gsub(/([a-z\d])([A-Z])/, '\1_\2').
        tr("-", "_").
        tr(".", "_").
        tr(",", "_").
        squish.
        tr(" ", "_").
        downcase.
        gsub('.', '').
        gsub('-', '').
        gsub(/[äöü]/) do |match|
      case match
        when "ä"
          'ae'
        when "ö"
          'oe'
        when "ü"
          'ue'
      end
    end
  end

  def self.escape_lookup_key(string)
    StringUtils.escape_username(string.gsub(' ', '_')).upcase
  end

end