class CreateHunts < ActiveRecord::Migration
  def self.up
    create_table :hunts do |t|
      t.references :map
      t.references :user
      t.datetime :finished_at

      t.timestamps
    end
  end

  def self.down
    drop_table :sessions
  end
end
