class AddHuntPositionsCount < ActiveRecord::Migration
  def self.up
    add_column :hunts, :positions_count, :integer, :default => 0
  end

  def self.down
    remove_column :hunts, :positions_count
  end
end