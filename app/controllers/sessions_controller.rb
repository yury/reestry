# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem

  def create
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        current_user.remember_me unless current_user.remember_token?
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
     reload_page
    else
      flash[:notice] = "Неверное имя пользователя или пароль"
      replace_html 'login_info', "<div class='login_error'>неверное имя или пароль</div>"
    end
  end

  def reload_page
    render :update, :layout => false do |page|
      page << "location.href = location.href.split('#')[0]"
    end
  end

  def replace_html id, html
    render :update, :layout => false do |page|
      page.replace_html  id, html
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end
end
