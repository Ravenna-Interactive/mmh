class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.decimal :lat
      t.decimal :lng
      t.references :session
      t.text :body
      t.string :attachment_file_name
      t.string :attachment_content_type
      t.integer :attachment_file_size
      t.datetime :attachment_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :notes
  end
end
