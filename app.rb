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
		password: params["password"])
	redirect to '/welcome'
end

get '/profile' do
	erb :profile
end

post '/profile' do
	Profile.create(age: params["age"], 
		city: params["city"], 
		occupation: params["occupation"],
	    user_id: params["user_id"]
		)
	    # erb :profile
	    redirect to '/welcome'
	end

get '/welcome' do
	erb :welcome
end

get '/allusers' do
	@users = User.all
	@posts = Post.all
	erb :allusers
end