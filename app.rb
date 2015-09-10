require 'sinatra'
require 'sinatra/activerecord'
require './models'
require 'rack-flash'
require 'bundler/setup'

set :database, "sqlite3:coffeetalk.sqlite3"

get '/' do 
	erb :index
	
end