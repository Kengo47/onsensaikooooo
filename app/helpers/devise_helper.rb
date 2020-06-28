module DeviseHelper
  def bootstrap_alert(key)
    case key
    when 'alert'
      'danger'
    when 'error'
      'danger'
    when 'notice'
      'success'
    end
  end

  def bootstrap_devise_error_messages!
    return '' if resource.errors.empty?

    html = []
    resource.errors.full_messages.each do |error_message|
      html << content_tag(:div, class: 'alert alert-danger alert-dismissible', role: 'alert') do
        content_tag(:span, error_message.to_s)
      end
    end
    safe_join html
  end
end
