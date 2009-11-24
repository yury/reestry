class UsersController < ApplicationController
  include UsersHelper 
  
  before_filter :login_required, :only => [ :add_contact, :destroy_contact ]
  before_filter :check_access, :only => [ :profile, :update ]
  
  # render new.rhtml
  def new
  end

  def profile
    @user = current_user
  end

  def create
    puts 'fall in user registration'
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    @user.is_admin = false
    @user.save
    puts @user.inspect
    if @user.errors.empty?
      self.current_user = @user
      flash[:notice] = "Регистрация прошла успешно!"

      reload_page
    else
      flash[:notice] = "Регистрация невозможна!"
      replace_html 'registration_info', "<div class='error'>#{@user.errors.first}</div>"
    end
  end

  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'Профиль успешно обновлен.'
        format.html { redirect_to(:action => "profile") }
        format.xml  { head :ok }
      else
        format.html { render :action => "profile" }
        format.xml  { render :xml => @location.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def add_contact
    contact = Contact.new(params[:contact])
    contact.user = current_user
    contact.save!

    checked = []
    checked = Realty.find(params[:realty_id]).contacts.map { |c| c.id } if params[:realty_id]
    
    respond_to do |format|
      format.js { user_contacts :allow_deleting => params[:allow_deleting], 
                                :allow_checking => params[:allow_checking],
                                :checked => checked}
    end
  end
  
  def delete_contact
    contact = Contact.find(params[:id])
    if current_user.contacts.include?(contact)
      contact.destroy
    end
    
    respond_to do |format|
      format.js { user_contacts :allow_deleting => true }
    end
  end
  
  private
  def check_access
    if authorized? && current_user.id.to_s == params[:id]
        return true
    end
    
    flash[:notice] = 'Доступ запрещен.'
    access_denied
  end
end
