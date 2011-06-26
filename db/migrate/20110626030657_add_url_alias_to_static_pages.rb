class AddUrlAliasToStaticPages < ActiveRecord::Migration
  def self.up
    add_column :static_pages, :url_alias, :string
  end

  def self.down
    remove_column :static_pages, :url_alias
  end
end
