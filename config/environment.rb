require 'bundler'
Bundler.require

require 'rspotify'
RSpotify.authenticate("28657c31a3fa4a119b91628095e055b9", "e5345123bf8b418885409bb56b54c3a8")


ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'
