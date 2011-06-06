class ApplicationController < ActionController::Base
  protect_from_forgery
  
  around_filter :manage_unsaved_maps
  
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
  
  
  def unsaved_maps
    @unsaved_maps ||= []
  end
  
  def clear_unsaved_maps!
    @unsaved_maps = []
  end
  
  def manage_unsaved_maps
    session[:map_ids] ||= []
    @unsaved_maps = session[:map_ids].empty? ? [] : Map.where(:id => session[:map_ids].compact)
    assign_session_maps_to_user(current_user) if current_user?
    yield
    session[:map_ids] = @unsaved_maps.collect { |map| map.id }
  end
  
  def assign_session_maps_to_user(user)
    unsaved_maps.each do |map|
      user.memberships.create(:map => map, :level => 'owner' )
    end
    clear_unsaved_maps!
  end
  
end
