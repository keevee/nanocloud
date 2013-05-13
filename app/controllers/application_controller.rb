class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale
  layout 'application'

  def initialize
    @js_data = {}
    super
  end

  def set_locale
    I18n.locale = :de
  end

  def js_data key, val
    @js_data["data-#{key}"] = val.to_json
  end

end
