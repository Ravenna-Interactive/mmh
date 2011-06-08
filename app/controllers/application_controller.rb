
class ApplicationController < ActionController::Base
  protect_from_forgery
  
  around_filter :manage_unsaved_map

  protected
  
  def current_user_session
    @current_user_session ||= UserSession.find
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user ||= current_user_session && current_user_session.user
  end
  alias_method :current_user?, :current_user
  helper_method :current_user?, :current_user
  
  
  def unsaved_map
    @unsaved_map
  end
  
  def unsaved_map=map
    @unsaved_map = map
    session[:unsaved_map_id] = map.id
  end
  
  def clear_unsaved_map!
    @unsaved_map = nil
  end
  
  def manage_unsaved_map
    session[:unsaved_map_id] ||= nil
    @unsaved_map = Map.find_by_id(session[:unsaved_map_id])
    assign_session_map_to_user(current_user) if current_user?
    yield
    session[:unsaved_map_id] = unsaved_map.id if unsaved_map
  end
  
  def assign_session_map_to_user(user)
    user.memberships.create :map => unsaved_map, :level => 'owner'
    clear_unsaved_map!
  end
      
  def api_request?
    request.format != :html
  end
  
  
end
