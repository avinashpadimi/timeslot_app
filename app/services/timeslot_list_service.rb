class TimeslotListService
  def initialize options
    @event = options[:event]
    @user = options[:user]
  end

  def call
    return render_failure({message: I18n.t("error.messages.unprocessable_entity") }) if @event.blank? || @user.blank?
    timeslots = Timeslot.includes(:users).by_event(@event)
    active_user_meetings = Meeting.active_meetings_by_user_event(@user,@event)

    #
    # Requirement:
    #
    # - Client needs to show all the time slots in an event, with the current user's active meetings.
    #   - If status is cancelled or rejected meetings shouldn't be shown, check Meeting-model for enum.
    #
    #  There isn't any direct way to pass dynamic conditions to Active Record Associations (while using Preload or Includes)
    #  
    #  In the current scenario we have to filter the meetings not the timeslots.
    #  Using the below Preloader API we can append filtered meetings to timeslots.
    #
    #  This approach would be efficient instead of identifying acitve user meetings in the serializer.
    #
    ActiveRecord::Associations::Preloader.new.preload(timeslots,:meetings,active_user_meetings)
    render_success({ timeslots: timeslots })
  end

  private

  def render_success payload
    build_resp({success: true, payload: payload})
  end

  def render_failure error
    build_resp({success: false, error: error})
  end

  def build_resp resp
    OpenStruct.new(resp)
  end
end
