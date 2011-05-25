
class HuntsController < ApplicationController
  respond_to :html, :json
  
  # Find the hunt to display
  # Pull up the map it belongs to
  # Render the hunt and the map together
  def show
    @hunt = current_user.hunts.find(params[:id])
    @map = @hunt.map
  end
  
  def create
    # find the hunt that this hunt is for
    @map = current_user.hunts.find(params[:map_id])
    @hunt = @map.hunts.build(:user => current_user)
    if @hunt.save
      respond_with @hunt
    else
      respond_with @hunt.errors      
    end
    
  end
  
  # post progress to a hunt
  # look up the hunt
  # TODO: make sure the hunt belongs to the current user
  def progress
    @hunt = current_user.hunts.find(params[:id])
    @locations = @hunt.add_locations params[:locations]
    
    # TODO: we need a way of getting note attachment data through JSON
    @notes = @hunt.add_notes params[:notes]
    # attach the notes and locations to the hunt
    
    # return a hash of the locations and notes in the same order that they were sent
    respond_with({ 'notes' => @notes, 'locations' => @locations })
    
  end
  
end
