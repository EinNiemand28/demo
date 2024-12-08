module OrdersHelper
  def order_status_badge_class(status)
    case status
    when 'unpaid'
      'bg-warning text-dark'
    when 'paid'
      'bg-info text-white'
    when 'shipped'
      'bg-primary text-white'
    when 'completed'
      'bg-success text-white'
    when 'canceled'
      'bg-secondary text-white'
    else
      'bg-light text-dark'
    end
  end
end