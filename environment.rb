require 'oii_twitter_goodies'
require 'sinatra'
require 'pry'
Dir[File.dirname(__FILE__) + '/model/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/extensions/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/handlers/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/helpers/*.rb'].each {|file| require file }
MongoMapper.connection = Mongo::Connection.new("127.0.0.1", 27017, :pool_size => 60, :pool_timeout => 60)
MongoMapper.database = "average_account"

set :erb, :layout => :'layouts/public'

enable :sessions
enable :logging

set :raise_errors, false
set :show_exceptions, false

helpers SessionHelper
helpers TwitterHelper
