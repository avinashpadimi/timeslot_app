class TimeslotsListService
  def initialize options
    @event = options[:event]
    @user = options[:user]
  end

  def execute
    timeslots = Timeslot.includes(:users).by_event(@event)
    active_user_meetings = Meeting.active_meetings_by_user_event(@user,@event)

    #TODO
    # Explain why this approach
    ActiveRecord::Associations::Preloader.new.preload(timeslots,:meetings,active_user_meetings)
    render_success({ timeslots: timeslots })
  end

  private

  def render_success payload
    OpenStruct.new({success: true, payload: payload})
  end
end
