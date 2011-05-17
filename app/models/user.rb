class User < ActiveRecord::Base
  acts_as_authentic
  
  has_many :memberships
  
  has_many :hunts, :through => :memberships
  has_many :sessions

  def owned_hunts
    hunts.where( { :memberships => { :level => 'owner' } } )
  end
  
  
end
