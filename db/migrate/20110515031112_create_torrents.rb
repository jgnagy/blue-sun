class CreateTorrents < ActiveRecord::Migration
  def self.up
    create_table :torrents do |t|
      t.string :name
      t.text :details
      t.text :filename
      t.integer :user_id
      t.text :hash

      t.timestamps
    end
    
    add_index :torrents, :name, :unique => true
    add_index :torrents, :filename, :unique => true
    add_index :torrents, :user_id
  end

  def self.down
    drop_table :torrents
  end
end
