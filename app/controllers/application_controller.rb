class ApplicationController < ActionController::Base
  before_action :basic_auth
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def configure_permitted_parameters
    added_attrs = [
      :nickname, :last_name, :first_name, :last_name_kana, :first_name_kana, :birth_date
    ]
    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
  end

  def basic_auth
    authenticate_or_request_with_http_basic do |u, p|
      u == ENV['BASIC_AUTH_USER'] && p == ENV['BASIC_AUTH_PASSWORD']
    end
  end
end
