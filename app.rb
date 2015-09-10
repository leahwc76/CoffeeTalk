require 'sinatra'
require 'sinatra/activerecord'
require 'bundler/setup'
require 'rack-flash'
require './models'

set :database, "sqlite3:coffeetalk.sqlite3"

get '/' do
	erb :index
end