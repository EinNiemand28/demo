class NotificationService
  FIELD_MAPPINGS = {
    '开始时间' => 'start_time',
    '结束时间' => 'end_time',
    '地点' => 'location',
    '状态' => 'status'
  }

  class << self
    def notify_event_update(event, changed_fields)
      return unless event.participants.exists?
      
      content = "活动「#{event.title}」发生变更：\n"
      changed_fields.each do |field|
        actual_field = FIELD_MAPPINGS[field]
        content += "#{field}已更新为#{event.send(actual_field)}\n"
      end
      
      notification = Notification.create!(
        content: content,
        notification_time: Time.current
      )
      
      event.participants.each do |participant|
        NotificationUser.create!(
          notification: notification,
          user: participant
        )
      end
    end

    def notify_event_start(event)
      return unless event.participants.exists?
      
      notification = Notification.create!(
        content: "活动「#{event.title}」将在1小时后开始，请准时参加。",
        notification_time: Time.current
      )
      
      event.participants.each do |participant|
        NotificationUser.create!(
          notification: notification,
          user: participant
        )
      end
    end

    def notify_event_approved(event)
      notification = Notification.create!(
        content: "您组织的活动「#{event.title}」已通过审核。",
        notification_time: Time.current
      )
      
      NotificationUser.create!(
        notification: notification,
        user: event.organizer_teacher
      )
    end

    def notify_volunteer_approved(student_volunteer_position)
      notification = Notification.create!(
        content: "您申请的志愿者岗位「#{student_volunteer_position.volunteer_position.name}」已通过审核。",
        notification_time: Time.current
      )
      
      NotificationUser.create!(
        notification: notification,
        user: student_volunteer_position.user
      )
    end

    def notify_volunteer_canceled(student_volunteer_position)
      notification = Notification.create!(
        content: "志愿者「#{student_student_volunteer_position.user.name}」取消了申请的志愿者岗位「#{student_volunteer_position.volunteer_position.name}」。",
        notification_time: Time.current
      )

      NotificationUser.create!(
        notification: notification,
        user: student_volunteer_position.volunteer_position.event.organizer_teacher
      )
    end

    def notify_event_feedback(event)
      return unless event.participants.exists?
      
      notification = Notification.create!(
        content: "活动「#{event.title}」已结束，期待您的反馈。",
        notification_time: Time.current
      )
      
      event.participants.each do |participant|
        NotificationUser.create!(
          notification: notification,
          user: participant
        )
      end
    end
  end
end