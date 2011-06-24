require 'military_alphabet'
# The core model of the app. It has a general location and has waypoints which show
# a hunt's route
class Map < ActiveRecord::Base
  
  has_many :waypoints, :order => :position
  has_many :hunts
  
  before_validation :auto_generate_name, :on => :create, :unless => :named?
  
    def total_distance
      Waypoint.select("sum(distance) as total_distance").where({:map_id => self.id}).first.total_distance
    end
    
    def thumbnail_image_url(options = {})
      options.reverse_merge!(
        :size => [50,50]
      )
      options[:size] = [options[:size], options[:size]] unless options[:size].kind_of?(Array)
      size = "#{options[:size].first}x#{options[:size].last}"
      location = "#{start_location.lat},#{start_location.lng}" if self.start_location.present?
      "http://maps.google.com/maps/api/staticmap?center=#{location}&zoom=12&size=#{size}&maptype=terrain&sensor=false"
    end
    
    def start_location
      self.waypoints.first
    end
    
    def named?
      self.name.present?
    end
  
  protected
  
    def auto_generate_name
      alphabet = MilitaryAlphabet.new
      character = alphabet[count]
      self.name = "Map #{character}"
      
    end
    
    def count
      Map.count
    end
      
end
