class MapsController < ApplicationController
  
  respond_to :html, :json
  before_filter :find_maps, :only => :index
  
  # a list of your hunts
  def index
  end
  
  # we're going to autosave new hunts and redirect
  # breaking REST contract here
  def new
      
    @map = Map.create
    if current_user
      current_user.memberships.create(:map => @map, :level => 'owner')
    else
      unsaved_maps << @map
    end
    redirect_to [:edit, @map]
  end
  
  # overview of the hunt
  # overlay the last hunt activity
  # show a list of sessions to display
  # show the notes on the map
  def show
    find_map
    respond_with @map, :include => :waypoints
  end
    
  # edit the hunt details/waypoints
  # the show and edit views will pretty much be the same action
  # since most editing will be javascript heavy using the Google Maps API
  def edit
    find_map
    respond_with @map, :include => :waypoints
  end
  
  protected
    
    
    def find_maps
      if current_user
        @maps = current_user.maps
      else
        @maps = unsaved_maps
      end
    end
    
    def find_map
      if current_user
        @map = current_user.owned_maps.find(params[:id])
      else
        @map = unsaved_maps.detect { |map| map.id.to_s == params[:id].to_s  }
      end
    end
  
end
