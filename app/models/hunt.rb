# Represents the actual activity of a user going out and hunting. This tracks an individuals activity for
# a specific hunt. Should we require a user to be within a certain distance of the first waypoint to start?
# 
# the client should be able to queue up all activity locally without interacting with a server
class Hunt < ActiveRecord::Base
  
  attr_protected :created_at, :udpated_at
  
  belongs_to :map
  belongs_to :user
  
  scope :recent, order('last_recorded_at DESC, finished_at DESC, started_at DESC').where("positions_count > 0")
  scope :active, where({:finished_at => nil})
  scope :finished, where(["finished_at < ?", Time.now])
  
  # the path/route this session took
  has_many :positions, :order => :recorded_at, :after_add => :update_recorded_at
  
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
  
  def map_progress_url(options={})
    options.reverse_merge! :width => 480, :height => 320
    gmap = GoogleStaticMap.new(:width => options[:width], :height => options[:height])
    
    # add the markers for the map
    map_path = MapPath.new(:weight => 3, :color => "0x00000099")
    current_location = positions.reorder('recorded_at DESC').first
    gmap.markers << MapMarker.new(:color => 'orange', :location => MapLocation.new(:latitude => current_location.lat , :longitude => current_location.lng )) if current_location.present?
    self.map.waypoints.each do |waypoint|
      location = MapLocation.new(:latitude => waypoint.lat, :longitude => waypoint.lng)
      gmap.markers << MapMarker.new(
        :icon => 'http://mmh.heroku.com/images/waypoint-marker.png',
        :shadow => false,
        :location => location,
      )
      map_path.points << location
    end
    gmap.paths << map_path
    logger.debug "URL: #{gmap.url}"
    gmap.url
  end
  
  protected
    
    def update_recorded_at(position)
      if self.last_recorded_at.nil? || self.last_recorded_at < position.recorded_at
        self.last_recorded_at = position.recorded_at
        self.save(false)
      end
    end
  
end
