class BaseController < ActionController::API
  before_action :authenticate_user!

  private

    def authenticate_user!
      render_error 401, I18n.t('error.messages.unauthorized') unless current_user
    end

    def current_user
      @current_user ||= User.find_by(id: request.headers['Authorization'] || nil)
    end

    def render_error error_code,message
      render json: {
        message: message,
        code: error_code
      }, status: I18n.t("error.codes.#{error_code}").to_sym and return
    end
end
