class UserSessionsController < ApplicationController
  
  respond_to :html, :json
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    respond_to do |format|
      if @user_session.save
        @user = @user_session.user
        format.json { render :json => { :email => @user.email, :id => @user.id, :single_access_token => @user.single_access_token } }
        format.html { redirect_to :activity}
      else
        format.json { render :json => @user_session.errors, :status => :unprocessable_entity }
        format.html { render :action => 'new' }
      end
    end
  end
  
  def destroy
    current_user_session.destroy
    redirect_to :root
  end
  
end
