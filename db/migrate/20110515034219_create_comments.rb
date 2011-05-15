class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :torrent_id
      t.integer :user_id
      t.text :details

      t.timestamps
    end
    add_index :comments, :torrent_id
    add_index :comments, [:user_id, :torrent_id]
  end

  def self.down
    drop_table :comments
  end
end
