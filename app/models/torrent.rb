class Torrent < ActiveRecord::Base
  require 'digest/md5'
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
  
  def current_hash
    return Digest::MD5.file(filename.current_path)
  end
  
  def magnet_available?
    return false
  end
  
  #def btih
  #  torrent_info = RubyTorrent::MetaInfo.from_location(filename.current_path)
  #  return torrent_info.hash
  #end
  
  #def magnet_link
  #  return "magnet:?xt=urn:btih:#{btih}"
  #end
end
