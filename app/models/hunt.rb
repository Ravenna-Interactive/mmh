# Represents the actual activity of a user going out and hunting. This tracks an individuals activity for
# a specific hunt. Should we require a user to be within a certain distance of the first waypoint to start?
# 
# the client should be able to queue up all activity locally without interacting with a server
class Hunt < ActiveRecord::Base
  
  attr_protected :created_at, :udpated_at
  
  belongs_to :map
  belongs_to :user
  
  scope :recent, :order => 'finished_at DESC, created_at DESC'
  
  # the path/route this session took
  has_many :positions, :order => :recorded_at
  
  # the notes/photos/videos made along the way
  has_many :notes, :order => :created_at
  
  def add_positions(location_data)
    location_data.collect { |location|
      self.positions.create(location)
    }
  end
  
  def started_at_ms=ms
    self.started_at = Time.at(ms.to_i/1000)
  end
  
  def started_at_ms
    self.started_at.to_i * 1000 if self.started_at?
  end


  def finished_at_ms=ms
    self.finished_at = Time.at(ms.to_i/1000)
  end
  
  def finished_at_ms
    self.finished_at.to_i * 1000 if self.finished_at?
  end
  
end
