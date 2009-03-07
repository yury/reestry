module UsersHelper
  def user_contacts options = {}
    options.reverse_merge!(:user => current_user, :allow_checking => false, :allow_deleting => false, :checked => [])
    render :partial => "users/user_contacts", :locals => options
  end
end