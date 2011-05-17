class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email
      t.string :salt
      t.string :crypted_password
      t.string :persistence_token
      t.datetime :current_login_at
      t.datetime :last_login_at
      t.string :current_login_ip
      t.string :last_login_ip
      t.integer :login_count
      t.integer :failed_login_count

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
