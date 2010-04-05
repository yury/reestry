#encoding: utf-8

# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.


class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  # protect_from_forgery :secret => 'a91202e243de84aabf3c804e9e9022eb'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

#  def rescue_action_in_public(exception)
#    handle_exception exception, false
#  end
#
#  def rescue_action_locally(exception)
#    handle_exception exception, false
#  end

  def run_rake task, options = {}
    options[:rails_env] = Rails.env
    args = options.map { |name, value| "#{name.to_s.upcase}='#{value}'" }
    system "rake #{task} #{args.join(' ')} --trace >> #{Rails.root}/log/rake.log &"
  end

  def reload_page
    render :update, :layout => false do |page|
      page << "location.href = location.href.split('#')[0]"
    end
  end

  def replace_html id, html
    render :update, :layout => false do |page|
      page.replace_html id, html
    end
  end

  def fragment_for(buffer, name = {}, options = nil, &block)
    if params['@@skip_cache']
      return block.call()
    end
    super
  end

  private
    def handle_exception(exception, is_local)
    locals = {}
    params['@@skip_cache'] = true
    locals[:exception] = is_local ? exception : ""
    if [ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid,
        ActionController::RoutingError,
        ActionController::UnknownController,
        ActionController::UnknownAction,
        ActionController::MethodNotAllowed].include? exception.class
      locals[:message] = "Запрашиваемая Вами страница не найдена"
      render :template => "all/error", :status => "404", :locals => locals
    else
      locals[:message] = "Ошибка на сервере. Мы делаем все возможное, чтобы её не было."
      render :template => "all/error", :status => "500", :locals => locals
    end
  end
end
