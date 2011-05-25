require 'military_alphabet'
# The core model of the app. It has a general location and has waypoints which show
# a hunt's route
class Map < ActiveRecord::Base
  
  has_many :waypoints, :order => :position
  
  before_validation :auto_generate_name, :on => :create
  
    def total_distance
      Waypoint.select("sum(distance) as total_distance").where({:map_id => self.id}).first.total_distance
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
