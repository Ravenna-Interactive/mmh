class ApplicationController < ActionController::Base
  protect_from_forgery
  
  around_filter :manage_unsaved_hunts
  
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
  
  
  def unsaved_hunts
    @unsaved_hunts ||= []
  end
  
  def manage_unsaved_hunts
    session[:hunt_ids] ||= []
    @unsaved_hunts = Hunt.where(:id => session[:hunt_ids])
    yield
    session[:hunt_ids] = @unsaved_hunts.collect { |hunt| hunt.id }
  end
  
end
