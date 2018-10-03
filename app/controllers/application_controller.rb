class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private
  
  before_action :set_locale
  
  def set_locale
    I18n.locale = I18n.default_locale
  end

  # ユーザーのログインを確認する
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてください"
      redirect_to login_url
    end
  end
end