class NotificationService
  FIELD_MAPPINGS = {
    '开始时间' => 'start_time',
    '结束时间' => 'end_time',
    '地点' => 'location',
    # '状态' => 'status'

    '名称' => 'name',
    '描述' => 'description',
    '志愿者时长' => 'volunteer_hours',
  }

  class << self
    def notify_event_updated(event, changed_fields)
      return unless event.participants.exists?
      
      content = "活动「#{event.title}」发生变更：\n"
      changed_fields.each do |field|
        actual_field = FIELD_MAPPINGS[field]
        old_value, new_value = event.saved_change_to_attribute(actual_field)
        content += "#{field}从#{format_value(old_value)}变更为#{format_value(new_value)}\n"
      end
      
      create_notification(content, event.participants)
    end

    def notify_event_start(event)
      return unless event.participants.exists?
      content = "活动「#{event.title}」将在1小时后开始, 请准时参加。"
      create_notification(content, event.participants)
    end

    def notify_event_canceled(event)
      content = "活动「#{event.title}」已取消。"
      create_notification(content, event.participants)
    end

    def notify_application_approved(application)
      content = "您申请的活动「#{application.title}」已通过审核。"
      create_notification(content, [application.applicant])
    end

    def notify_application_rejected(application)
      content = "您申请的活动「#{application.title}」未通过审核。"
      create_notification(content, [application.applicant])
    end

    def notify_volunteer_position_updated(volunteer_position, changed_fields)
      content = "志愿者岗位「#{volunteer_position.name}」发生变更：\n"
      changed_fields.each do |field|
        actual_field = FIELD_MAPPINGS[field]
        old_value, new_value = volunteer_position.saved_change_to_attribute(actual_field)
        content += "#{field}从#{format_value(old_value)}变更为#{format_value(new_value)}\n"
      end

      create_notification(content, volunteer_position.volunteers)
    end

    def notify_volunteer_approved(student_volunteer_position)
      content =  "您申请的志愿者岗位「#{student_volunteer_position.volunteer_position.name}」已通过审核。"
      create_notification(content, [student_volunteer_position.user])
    end

    def notify_volunteer_canceled(student_volunteer_position)
      content = "志愿者「#{student_student_volunteer_position.user.name}」取消了申请的志愿者岗位「#{student_volunteer_position.volunteer_position.name}」。"
      create_notification(content, [student_volunteer_position.volunteer_position.event.organizing_teacher])
    end

    def notify_event_feedback(event)
      return unless event.participants.exists?
      
      content = "活动「#{event.title}」已结束，期待您的反馈。"
      create_notification(content, event.participants)
    end

    private
    def create_notification(content, recipients)
      return if recipients.empty?

      notification = Notification.create!(content: content)
      recipients.each do |recipient|
        NotificationUser.create!(
          notification: notification, 
          user: recipient
        )
      end
    end

    def format_value(value)
      case value
      when Time
        l value, format: :long
      when true
        '是'
      when false
        '否'
      else
        value.to_s
      end
    end
  end
end