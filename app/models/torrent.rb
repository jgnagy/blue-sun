class Torrent < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  has_many :ratings
  
  mount_uploader :filename, TorrentFileUploader
  
  # returns an average rounded to the nearest half (keeps the number of ratings images to 10)
  def rating
    raw_avg = ratings.average(:value)
    decimal = raw_avg % 1
    return decimal > 0.5 ? (raw_avg - decimal) + 0.5 : raw_avg - decimal
  end
end
