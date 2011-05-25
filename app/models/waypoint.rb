class Waypoint < ActiveRecord::Base
  validates_presence_of :map_id, :name, :lat, :lng
  validates_numericality_of :lat, :lng
  belongs_to :map
  
  before_validation :auto_generate_name, :on => :create, :if => :map_id?
  
  acts_as_list :scope => :map_id
  
  attr_accessor :next, :previous
  
  def next?
    !self.next.nil?
  end
  
  def previous?
    !self.previous.nil?
  end
  
  protected
        
    def auto_generate_name
      alphabet = MilitaryAlphabet.new
      character = alphabet[count]
      self.name = character
    end
  
    def count
      self.map.waypoints.count
    end
  
end
