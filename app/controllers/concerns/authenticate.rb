module Authenticate
  extend ActiveSupport::Concern

  included do
    before_action :authenticate
    before_action :require_login, unless: :logged_in?

    helper_method :logged_in?
  end

  class_methods do
    def skip_authentication(**options)
      skip_before_action :authenticate, options
      skip_before_action :require_login, options
    end

    def allow_unauthenticated(**options)
      skip_before_action :require_login, options
    end
  end

  protected

    def logged_in?
      Current.user.present?
    end

    def log_in(app_session, remember_me)
      if remember_me
        cookies.encrypted.permanent[:app_session] = {
          value: app_session.to_h
        }
      else
        session[:app_session] = app_session.to_h
      end
    end

    def log_out
      Current.app_session&.destroy
      session.delete(:app_session) if session[:app_session]
      cookies.delete(:app_session) if cookies.encrypted[:app_session]
    end

  private

    def require_login
      flash.now[:notice] = t("login_required")
      render "sessions/new", status: :unauthorized
    end

    def authenticate
      Current.app_session = authenticate_using(session_data)
      Current.user = Current.app_session&.user
    end

    def session_data
      is_using_cookie = cookies.encrypted[:app_session]
      app_session = is_using_cookie ? cookies.encrypted[:app_session]
        : session[:app_session]
      app_session&.with_indifferent_access
    end

    def authenticate_using(data)
      data => { user_id:, app_session:, token: }

      user = User.find(user_id)
      user.authenticate_app_session(app_session, token)
    rescue NoMatchingPatternError, ActiveRecord::RecordNotFound
      nil
    end
end
