module ClientUtils

  def self.classname(object)
    object.class.to_s.split("(")[0]
  end

  def self.get_operating_system
    if (defined? request) && (defined? request.env['HTTP_USER_AGENT'])
      if request.env['HTTP_USER_AGENT'].downcase.match(/mac/i)
        "Mac"
      elsif request.env['HTTP_USER_AGENT'].downcase.match(/windows/i)
        "Windows"
      elsif request.env['HTTP_USER_AGENT'].downcase.match(/linux/i)
        "Linux"
      elsif request.env['HTTP_USER_AGENT'].downcase.match(/unix/i)
        "Unix"
      elsif request.env['HTTP_USER_AGENT'].downcase.match(/android/i)
        "Android"
      elsif request.env['HTTP_USER_AGENT'].downcase.match(/ios/i)
        "iOS"
      else
        ""
      end
    else
      ""
    end
  end

end