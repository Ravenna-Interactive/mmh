class HuntsController < ApplicationController
  
  respond_to :html, :json
  
  # a list of your hunts
  def index
    @hunts = Hunt.all
  end
  
  # we're going to autosave new hunts and redirect
  # breaking REST contract here
  def new
    @hunt = Hunt.create
    redirect_to @hunt
  end
    
  # shows the hunt details
  # the show and edit views will pretty much be the same action
  # since most editing will be javascript heavy using the Google Maps API
  def show
    @hunt = Hunt.find(params[:id])
    respond_with @hunt, :include => :waypoints
  end
  
end
