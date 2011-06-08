class CreatePositions < ActiveRecord::Migration
  def self.up
    create_table :positions do |t|
      t.decimal :lat
      t.decimal :lng
      t.references :hunt

      t.timestamps
    end
  end

  def self.down
    drop_table :positions
  end
end