class User < ActiveRecord::Base
  acts_as_authentic
  
  has_many :memberships
  
  has_many :hunts, :through => :memberships

  def owned_hunts
    hunts.where( { :memberships => { :level => 'owner' } } )
  end
  
  
end
