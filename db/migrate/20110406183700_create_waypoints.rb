class CreateWaypoints < ActiveRecord::Migration
  def self.up
    create_table :waypoints do |t|
      t.string :name
      t.integer :position
      t.references :map
      t.decimal :lat, :precision => 15, :scale => 10
      t.decimal :lng, :precision => 15, :scale => 10
      t.decimal :distance, :precision => 10, :scale => 3
      t.decimal :heading, :precision => 10, :scale => 7
      t.timestamps
    end
  end

  def self.down
    drop_table :way_points
  end
end
