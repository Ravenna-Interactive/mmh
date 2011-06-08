class FixPositionTimestampColumn < ActiveRecord::Migration
  def self.up
    rename_column :positions, :timestamp, :recorded_at
    change_column :positions, :recorded_at, :datetime
  end

  def self.down
    change_column :positions, :recorded_at, :integer
    rename_column :positions, :recorded_at, :timestamp
  end
end