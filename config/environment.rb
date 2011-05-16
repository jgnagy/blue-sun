# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
BlueSun::Application.initialize!

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

APP_CONFIG = ENV['BLUESUN_HOME'] ? YAML.load_file("#{ENV['BLUESUN_HOME']}/config/blue-sun.yaml") : generic_config
APP_CONFIG.freeze
DATA_DIR = ENV['BLUESUN_HOME'] ? "#{ENV['BLUESUN_HOME']}/data" : "/tmp/blue-sun/data"
DATA_DIR.freeze
FileUtils.mkdir_p(DATA_DIR) unless ENV['BLUESUN_HOME']

generic_config = nil