
class SessionsController < ApplicationController
  respond_to :html, :json
  
  # Find the session to display
  # Pull up the hunt it belongs to
  # Render the hunt and the session together on a map
  def show
    @session = current_user.sessions.find(params[:id])
    @hunt = @session.hunt
  end
  
  def create
    # find the hunt that this session is for
    @hunt = current_user.hunts.find(params[:hunt_id])
    @session = @hunt.sessions.build(:user => current_user)
    if @session.save
      respond_with @session
    else
      respond_with @session.errors      
    end
    
  end
  
  # post progress to a hunt
  # look up the session
  # TODO: make sure the session belongs to the current user
  def progress
    @session = current_user.sessions.find(params[:id])
    @locations = @session.add_locations params[:locations]
    
    # TODO: we need a way of getting note attachment data through JSON
    @notes = @session.add_notes params[:notes]
    # attach the notes and locations to the session
    
    # return a hash of the locations and notes in the same order that they were sent
    respond_with { 'notes' => @notes, 'locations' => @locations }
    
  end
  
end
