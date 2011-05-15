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
    exit 0
  end
end

# Setup the DB if it hasn't been setup before
require 'rake'
ActiveRecord::Migrator.migrate('db/migrate', nil)

# unset the values, just to make sure they aren't accidentally used somewhere else
generic_config = nil
config_file = nil