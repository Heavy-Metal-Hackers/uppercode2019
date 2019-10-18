module ApplicationHelper

  #def cart
  #  JSON.parse cookies.signed[:cart] rescue nil
  #end

  def current_guest
    Guest.first # mocked up
  end

  def namespace
    if controller.class.parent.blank? || controller.class.parent.name.blank? || controller.class.parent.name == 'Object'
      nil
    else
      controller.class.parent.name.underscore
    end

  end

  def ldate(dt, hash = {})
    dt ? l(dt, hash) : nil
  end

  def lrelativedate(dt, hash = {})
    if dt.present?
      if Date.today.mjd - dt.to_date.mjd > 1
        time_ago_in_words(dt)
      else
        l(dt, hash)
      end
    else
      nil
    end
  end

  def tn(key, options = {})
    return nil if key.nil?
    return "" if key == ""
    t(key, options)
  end
end
