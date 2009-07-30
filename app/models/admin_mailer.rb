class AdminMailer < ActionMailer::Base
  def parse_notification parser_name, result
     subject    "#{parser_name} parsing results"
     recipients "nikolay.zhebrun@gmail.com"
     from       "admin@reestry.ru"
     body       result
  end
end
