class ActivityController < ApplicationController
  
  before_filter :require_user, :except => :public
  
  def index
    @timeline = current_user.timeline
    @hunts = current_user.hunts.order('created_at DESC').limit(10)
  end
  
  def public
    @active = Hunt.recent.active
    @recent = Hunt.recent.finished
  end
  
end
