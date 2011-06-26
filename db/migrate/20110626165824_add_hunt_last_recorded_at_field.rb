class AddHuntLastRecordedAtField < ActiveRecord::Migration
  def self.up
    add_column :hunts, :last_recorded_at, :datetime
    Hunt.find_each do |h|
      h.last_recorded_at = h.positions.order('recorded_at DESC').first.recorded_at
      h.save(false)
    end
  end

  def self.down
    remove_column :hunts, :last_recorded_at
  end
end