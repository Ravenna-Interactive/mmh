class ActivityController < ApplicationController
  
  
  def index
    @timeline = current_user.timeline
  end
  
end
