class String
  def underscore
    self.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
        gsub(/([a-z\d])([A-Z])/, '\1_\2').
        tr("-", "_").
        tr(".", "_").
        tr(",", "_").
        squish.
        tr(" ", "_").
        downcase.
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
end

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session, unless: -> {request.format.json? || request.format.xml? || request.format.xls? || request.format.csv?}
  #before_filter :set_locale, :unless => :is_json
  before_action :treat_params
  #before_filter :authenticate_user!, :unless => [:is_json, ...]

  require('ibm_watson/assistant_v2')
  require('json')

  ibm_watson_assistant = IBMWatson::AssistantV1.new(
      username: 'ba6ef3b3-483c-471c-9e60-22e5ffd906f5',
      password: "EgONGcOkyLs5",
      version: '2018-09-17'
  )

  def underscore(obj)
    if act_as_hash obj
      obj.keys.each do |k|
        v = obj[k]
        v = underscore v if act_as_hash v
        obj.delete k
        obj[underscore(k)] = v
      end
    elsif obj.class == String || obj.class == Symbol
      sym = true if obj.class == Symbol

      obj = obj.to_s.gsub(/::/, '/').gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').gsub(/([a-z\d])([A-Z])/, '\1_\2').tr("-", "_").downcase
      obj = obj.to_sym if sym == true
    end
    obj
  end

  def treat_params
    underscore params if params
  end

  # changes params[model][p1] for params[model][p2]
  def change_parameter(model, p1, p2)
    if model.class == Array
      if params
        p = params
        model.each do |m|
          p = p[m] if p[m]
        end
        unless p[p1].blank?
          v = p[p1]
          p.delete p1
          p[p2] = v
        end
      end
    else
      if params && params[model] && !params[model][p1].blank?
        v = params[model][p1]
        params[model].delete p1
        params[model][p2] = v
      end
    end
  end

  def is_hash_empty?(hash)
    empty = true
    hash.keys.each do |k|
      empty = false unless hash[k].blank?
    end
    empty
  end

  def set_locale
    I18n.locale = params[:locale] || (current_user && current_user.locale ? current_user.locale : false) || I18n.default_locale
    # current_user.update_attributes locale: I18n.locale.to_s if current_user and I18n.locale.to_s != current_user.locale
  end

  def default_url_options(options={})
    {:locale => I18n.locale}
  end

  def ldate(dt, hash = {})
    dt ? l(dt, hash) : nil
  end

  private
  def act_as_hash(obj)
    obj.class == hash || obj.class.method_defined?(:keys)
  end

end
