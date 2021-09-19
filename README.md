
Tables:

 Users
 Meetings
 Timeslots
 Event
 
 ================
 Relations:
 
 Event has many Timeslots.
 
 Timeslot has many meeting
 
 User has many meetings
 
 =======================
 
 - Get all the timeslots of an event with active meetings of the user. (Active meetings mean : status should not be cancelled or rejected)
 - Information of the users who participate in those meetings also.

##### Use-case:
To show a schedule for an event, to see if there are any meetings booked for me,
    and to see users who participate in timeslots, so I could book meetings with them.
