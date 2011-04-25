class HuntsController < ApplicationController
  
  respond_to :html, :json
  before_filter :find_hunts, :only => :index
  
  # a list of your hunts
  def index
  end
  
  # we're going to autosave new hunts and redirect
  # breaking REST contract here
  def new
      
    @hunt = Hunt.create
    if current_user
      current_user.memberships.create(:hunt => @hunt, :level => 'owner')
    else
      unsaved_hunts << @hunt
    end
    redirect_to @hunt
  end
    
  # shows the hunt details
  # the show and edit views will pretty much be the same action
  # since most editing will be javascript heavy using the Google Maps API
  def show
    if current_user
      @hunt = current_user.owned_hunts.find(params[:id])
    else
      @hunt = unsaved_hunts.detect { |hunt| hunt.id.to_s == params[:id].to_s  }
    end
    
    respond_with @hunt, :include => :waypoints
  end
  
  protected
    
    
    def find_hunts
      if current_user
        @hunts = current_user.hunts
      else
        @hunts = unsaved_hunts
      end
    end
  
end
