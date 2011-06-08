# For tracking a user's location during a hunting Session these are the stored location
# updates that come from the iPhone client
class Position < ActiveRecord::Base
  belongs_to :hunt
    
end
