class CreateSessions < ActiveRecord::Migration
  def self.up
    create_table :sessions do |t|
      t.references :hunt
      t.references :user
      t.datetime :finished_at

      t.timestamps
    end
  end

  def self.down
    drop_table :sessions
  end
end
