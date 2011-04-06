require 'military_alphabet'
# The core model of the app. It has a general location and has waypoints which show
# a hunt's route
class Hunt < ActiveRecord::Base
  
  has_many :waypoints, :order => :position
  
  before_validation :auto_generate_name, :on => :create
  
  protected
  
    def auto_generate_name
      alphabet = MilitaryAlphabet.new
      character = alphabet[count]
      self.name = "Hunt #{character}"
      
    end
    
    def count
      Hunt.count
    end
      
end
