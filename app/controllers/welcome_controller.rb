class WelcomeController < BaseController
  def index
    render json: UserSerializer.new(current_user)
  end
end
