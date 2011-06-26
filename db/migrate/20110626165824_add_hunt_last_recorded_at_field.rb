class AddHuntLastRecordedAtField < ActiveRecord::Migration
  def self.up
    add_column :hunts, :last_recorded_at, :datetime
    Hunt.find_each do |h|
      last_position = h.positions.order('recorded_at DESC').first
      h.last_recorded_at = last_position.recorded_at if last_position.present?
      h.save(false)
    end
  end

  def self.down
    remove_column :hunts, :last_recorded_at
  end
end