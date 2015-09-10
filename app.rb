require 'sinatra'
require 'sinatra/activerecord'
require './models'
require 'bundler/setup'
require 'rack-flash'

set :database, "sqlite3:coffeetalk.sqlite3"

get '/' do 
	erb :index
end

get '/login' do
	erb :index
end

get '/signup' do
	erb :signup
end

post '/create' do
	User.create(fname: params["fname"], 
		lname: params["lname"], 
		phone: params["phone"],
		email: params["email"],
		username: params["username"],
		password: params["password"]
		)
	redirect to '/welcome'
end

get '/profile' do
	erb :profile
end

get '/welcome' do
	erb :welcome
end

get '/allusers' do
	@users = User.all
	erb :allusers
end