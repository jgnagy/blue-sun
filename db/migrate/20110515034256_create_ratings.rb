class CreateRatings < ActiveRecord::Migration
  def self.up
    create_table :ratings do |t|
      t.integer :torrent_id
      t.integer :user_id
      t.integer :value

      t.timestamps
    end
    add_index :ratings, [:user_id, :torrent_id], :unique => true
    add_index :ratings, :torrent_id
    add_index :ratings, :value
  end

  def self.down
    drop_table :ratings
  end
end
