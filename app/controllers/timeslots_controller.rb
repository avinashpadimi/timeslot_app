class TimeslotsController < BaseController
  before_action :valid_event!

  def index
    resp = TimeslotListService.new({ event: @current_event,user: @current_user}).call
    render_error 422, resp.error[:message] || I18n.t("error.messages.unprocessable_entity") unless resp.success
    render json: TimeslotSerializer.new(resp.payload[:timeslots],{ include: [:meetings, :users]}).serializable_hash.to_json, status: :ok
  end

  private

  def valid_event!
    render_error 403, I18n.t("error.messages.forbidden") unless current_event
  end
  
  def current_event 
    @current_event ||= Event.find_by(id: params[:event_id])
  end
end
