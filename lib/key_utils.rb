module KeyUtils

  def self.classname(object)
    object.class.to_s.split("(")[0]
  end

  def self.translate_key(key)
    if key.blank?
      ''
    else
      translation = Internationalization.find_by key: ('KeyName.Key_' + classname(key)[3..-1] + '.' + key.key), locale: I18n.locale
      if translation.blank?
        key.key.to_s
      else
        translation.value
      end
    end
  end
end