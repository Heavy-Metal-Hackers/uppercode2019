module I18nUtils

  def self.classname(object)
    object.class.to_s.split("(")[0]
  end

  def self.ldate(dt, hash = {})
    dt ? I18n.l(dt, hash) : nil
  end
end