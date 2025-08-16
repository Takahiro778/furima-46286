class ApplicationController < ActionController::Base
  before_action :basic_auth, if: :basic_auth_enabled?
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def configure_permitted_parameters
    added_attrs = %i[nickname last_name first_name last_name_kana first_name_kana birth_date]
    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
    # （任意）プロフィール編集画面を使うなら：
    # devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
  end

  def basic_auth_enabled?
    Rails.env.production? # 本番のみBasic認証を有効化
  end

  def basic_auth
    authenticate_or_request_with_http_basic do |u, p|
      u == ENV['BASIC_AUTH_USER'] && p == ENV['BASIC_AUTH_PASSWORD']
    end
  end
end
