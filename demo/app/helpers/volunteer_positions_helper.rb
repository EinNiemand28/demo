module VolunteerPositionsHelper
  def registration_status_badge_class(status)
    case status
    when 'pending' then 'bg-warning'
    when 'approved' then 'bg-success'
    when 'canceled' then 'bg-secondary'
    end
  end

  def registration_status(status)
    t("activerecord.enums.student_volunteer_position.#{status}")
  end
end