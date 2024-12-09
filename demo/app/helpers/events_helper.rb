module EventsHelper
  def event_status(status)
    case status
    when 'pending'
      t('activerecord.enums.event.pending')
    when 'upcoming'
      t('activerecord.enums.event.upcoming')
    when 'ongoing'
      t('activerecord.enums.event.ongoing')
    when 'finished'
      t('activerecord.enums.event.finished')
    when 'canceled'
      t('activerecord.enums.event.canceled')
    end
  end

  def event_status_badge_class(status)
    case status
    when 'pending'
      'bg-info text-dark'
    when 'upcoming'
      'bg-success text-white'
    when 'ongoing'
      'bg-primary text-white'
    when 'finished'
      'bg-warning text-white'
    when 'canceled'
      'bg-secondary text-white'
    end
  end
end
