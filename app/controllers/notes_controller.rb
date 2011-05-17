class NotesController < ApplicationController
  
  respond_to :html, :json
  
  # create a note for the given session
  def create
    @session = current_user.sessions.find(params[:id])
    @note = Session.notes.build(params[:note])
    if @note.save
      respond_with @note
    else
      respond_with @note.errors
    end
  end
  
  # just show the note
  def show
    @note = Note.find(params[:id])
    respond_with @note
  end
  
end
