class MapsController < ApplicationController
  
  respond_to :html, :json
  before_filter :require_user, :only => [:index]
  before_filter :find_maps, :only => :index

  # a list of your hunts
  def index
    @maps = current_user.owned_maps
    respond_with @maps, :include => :waypoints
  end
  
  # we're going to autosave new hunts and redirect
  # breaking REST contract here
  def new
      
    if current_user
      @map = Map.create
      current_user.memberships.create(:map => @map, :level => 'owner')
    else
      self.unsaved_map = Map.create unless unsaved_map
      @map = unsaved_map
    end
    redirect_to [:edit, @map]
  end
  
  def create
    @map = Map.new(params[:map])
    if current_user
      current_user.memberships.create(:map => @map, :level => 'owner')
    else
      unsaved_map = @map
    end
    if @map.save
      respond_with @map, :include => :waypoints
    else
      respond_with @map.errors
    end
  end
  
  # overview of the hunt
  # overlay the last hunt activity
  # show a list of sessions to display
  # show the notes on the map
  def show
    find_map
    respond_to do |format|
      format.html do
        redirect_to edit_map_path(@map)
      end
      format.any(:json, :xml) do
        respond_with @map, :include => :waypoints
      end
    end

  end
    
  # edit the hunt details/waypoints
  # the show and edit views will pretty much be the same action
  # since most editing will be javascript heavy using the Google Maps API
  def edit
    find_map
    respond_with @map, :include => :waypoints
  end
  
  
  def destroy
    find_map
    @map.destroy
    respond_with @map
  end
  
  
  protected
    
    
    def find_maps
      if current_user
        @maps = current_user.maps
      else
        @maps = [unsaved_map].compact
      end
    end
    
    def find_map
      if current_user
        @map = current_user.owned_maps.find(params[:id])
      else
        @map = unsaved_map
      end
    end
    
end
