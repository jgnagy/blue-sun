# Load the rails application
require File.expand_path('../application', __FILE__)

generic_config = {
  :db => {
    "adapter" => "jdbcmysql",
    "encoding" => "utf8",
    "reconnect" => false,
    "database" => "blue-sun_test",
    "pool" => 5,
    "username" => "root",
    "password" => "",
    "socket" => "/tmp/mysql.sock"
  }
}

if ENV['BLUESUN_HOME']
  require 'fileutils'
  ["data", "config"].each do |dir|
    FileUtils.mkdir_p("#{ENV['BLUESUN_HOME']}/#{dir}")
  end
  
  config_file = "#{ENV['BLUESUN_HOME']}/config/blue-sun.yaml"
  unless File.exists?(config_file)
    File.open(config_file, 'w') do |out|
      YAML.dump(generic_config, out)
    end
    puts "Config file generated @ #{ENV['BLUESUN_HOME']}/config/blue-sun.yaml"
    puts "Please review this file and make any needed changes."
  end
end

APP_CONFIG = ENV['BLUESUN_HOME'] ? YAML.load_file("#{ENV['BLUESUN_HOME']}/config/blue-sun.yaml") : generic_config
APP_CONFIG.freeze
DATA_DIR = ENV['BLUESUN_HOME'] ? "#{ENV['BLUESUN_HOME']}/data" : "/tmp/blue-sun/data"
DATA_DIR.freeze
FileUtils.mkdir_p(DATA_DIR) unless ENV['BLUESUN_HOME']

# Initialize the rails application
BlueSun::Application.initialize!

generic_config = nil