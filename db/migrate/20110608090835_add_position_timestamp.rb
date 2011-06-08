class AddPositionTimestamp < ActiveRecord::Migration
  def self.up
    add_column :positions, :timestamp, :integer
    
    Position.update_all("timestamp = created_at")
  end

  def self.down
    remove_column :positions, :timestamp
  end
end