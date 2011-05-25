class WaypointsController < ApplicationController
  
  respond_to :html, :json
  
  before_filter :find_map, :only => [:create]
  
  def create
    @waypoint = @map.waypoints.build(params[:waypoint])
    flash[:notice] = "Waypoint created" if @waypoint.save
    respond_with(@waypoint)
  end
  
  def update
    @waypoint = Waypoint.find(params[:id])
    @waypoint.attributes = params[:waypoint]
    flash[:notice] = "Waypoint updated" if @waypoint.save
    
    respond_with(@waypoint)
  end
  
  def show
    @waypoint = Waypoint.find(params[:id])
    respond_with(@waypoint)
  end
  
  def destroy
    @waypoint = Waypoint.find(params[:id])
    flash[:notice] = "Waypoint deleted" if @waypoint.destroy
    respond_with(@waypoint)
  end
  
  protected
  
    def find_map
      @map = Map.find(params[:map_id])
    end
  
end
