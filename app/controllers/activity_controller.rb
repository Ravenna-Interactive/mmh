class ActivityController < ApplicationController
  
  
  def index
    @timeline = current_user.timeline
    @hunts = current_user.hunts.order('created_at DESC').limit(10)
  end
  
end
