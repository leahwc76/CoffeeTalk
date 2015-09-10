require 'sinatra'
require 'sinatra/activerecord'
require './models'
require 'rack-flash'
require './user'

set :database, "sqlite3:coffeetlk.sqlite3"
