class UsersController < ApplicationController
  
  # signup page
  def new
    @user = User.new
  end
  
  # create the account
  def create
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        unsaved_maps.each do |map|
          @user.memberships.create(:map => map, :level => 'owner' )
        end
        flash[:notice] = 'Account created.'
        format.html { redirect_to :root }
      else
        format.html { render :action => 'new' }
      end
    end
  end
    
end
