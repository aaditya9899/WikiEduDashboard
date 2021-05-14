# frozen_string_literal: true

class CourseApprovalFollowupWorker
  FOLLOWUP_DELAY = 3.days
  THIRTY_DAYS = 60 * 60 * 24 * 30
  include Sidekiq::Worker
  sidekiq_options lock: :until_executed,
                  lock_ttl: THIRTY_DAYS

  def self.schedule_followup_email(course:, instructor:)
    perform_in(FOLLOWUP_DELAY, course.id, instructor.id)
  end

  def perform(course_id, instructor_id)
    course = Course.find(course_id)
    instructor = User.find(instructor_id)
    CourseApprovalFollowupMailer.send_followup(course, instructor)
  end
end
