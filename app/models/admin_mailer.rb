class AdminMailer < ActionMailer::Base
  def parse_notification parser_name, result
#     subject    "#{parser_name} parsing results"
#     recipients "nikolay.zhebrun@gmail.com"
#     from       "admin@reestry.ru"
#     body       result

    subject 'Harvester Health Report'
    recipients 'nikolay.zhebrun@gmail.com'
    from 'admin@reestry.ru'
    sent_on Time.now#sent_at
    body 'Hi,'
    content_type "text/html"
  end
end
