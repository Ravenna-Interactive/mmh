class User < ActiveRecord::Base
  acts_as_authentic
  
  has_many :memberships
  
  has_many :maps, :through => :memberships
  has_many :hunts

  def owned_maps
    maps.where( { :memberships => { :level => 'owner' } } )
  end
  
  def timeline
    []
  end
  
end
