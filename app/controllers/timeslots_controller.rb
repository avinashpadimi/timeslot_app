class TimeslotsController < BaseController
  before_action :valid_event!

  def index
    resp = TimeslotsListService.new({ event: @current_event,user: @current_user}).execute
    render_error 422, I18n.t("error.messages.unprocessable_entity") and return unless resp.success
    timeslots = resp.payload[:timeslots]
    render json: TimeslotSerializer.new(timeslots,{ include: [:meetings, :users]}).serializable_hash.to_json, status: :ok
  end

  private

  def valid_event!
    render_error 403, I18n.t("error.messages.forbidden") and return unless current_event
  end
  
  def current_event 
    @current_event ||= Event.find_by(id: params[:event_id])
  end
end
