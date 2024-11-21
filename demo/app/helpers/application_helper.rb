module ApplicationHelper
  def format_datetime(datetime)
    datetime&.in_time_zone&.strftime('%Y-%m-%d %H:%M')
  end

  def format_date(date)
    date&.in_time_zone&.strftime('%Y-%m-%d')
  end

  # <%= back_link '返回', class: 'button' %>
  def back_link(text = '返回', **options)
    link_to text, :back, **options
  end

  # <%= back_button '返回', class: 'button' %>
  def back_button(text = '返回', **options)
    button_to text, :back, method: :get, **options
  end
end
