# Setup the DB if it hasn't been setup before
require 'rake'
ActiveRecord::Migrator.migrate('db/migrate', nil)