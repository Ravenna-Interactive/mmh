# Represents the actual activity of a user going out and hunting. This tracks an individuals activity for
# a specific hunt. Should we require a user to be within a certain distance of the first waypoint to start?
# 
# the client should be able to queue up all activity locally without interacting with a server
class Hunt < ActiveRecord::Base
  belongs_to :map
  belongs_to :user
  
  # the path/route this session took
  has_many :positions, :order => :recorded_at
  
  # the notes/photos/videos made along the way
  has_many :notes, :order => :created_at
  
  def add_positions(location_data)
    location_data.collect { |location|
      self.positions.create(location)
    }
  end
  
end
