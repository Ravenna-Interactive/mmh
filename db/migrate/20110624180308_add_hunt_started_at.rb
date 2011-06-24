class AddHuntStartedAt < ActiveRecord::Migration
  def self.up
    add_column :hunts, :started_at, :datetime
    Hunt.update_all "started_at = created_at",  "started_at IS NULL"
  end

  def self.down
    remove_column :hunts, :started_at
  end
end