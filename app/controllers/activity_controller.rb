class ActivityController < ApplicationController
  
  before_filter :require_user, :except => :public
  
  def index
    @timeline = current_user.timeline
    @hunts = current_user.hunts.order('created_at DESC').limit(10)
  end
  
  def public
    @hunts = Hunt.recent.limit(5)
  end
  
end
