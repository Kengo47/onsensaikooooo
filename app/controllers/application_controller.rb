class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name, :avatar, :avatar_cache])
    end

    # ログアウト後のリダイレクト先
    def after_sign_out_path_for(resource)
      search_posts_path
    end
end
