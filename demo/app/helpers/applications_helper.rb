module ApplicationsHelper
  def application_status(status)
    case status
    when 'pending'
      t('activerecord.enums.application.pending')
    when 'approved'
      t('activerecord.enums.application.approved')
    when 'rejected'
      t('activerecord.enums.application.rejected')
    end
  end

  def application_status_badge_class(status)
    case status
    when 'pending'
      'bg-warning text-white'
    when 'approved'
      'bg-success text-white'
    when 'rejected'
      'bg-danger text-white'
    end
  end
end