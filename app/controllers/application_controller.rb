class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale
  include SessionsHelper
  include ProjectsHelper
  include IssuesHelper

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t "controllers.application.please_login"
      redirect_to login_url
    end
  end

  def default_url_options
    { locale: I18n.locale }
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end