class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale
  layout 'application'

  def set_locale
    I18n.locale = :de
  end

end
