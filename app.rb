require 'sinatra'
require 'sinatra/activerecord'
require './models'
require 'bundler/setup'
require 'rack-flash'

set :database, "sqlite3:coffeetalk.sqlite3"
set :sessions, true
use Rack::Flash, sweep: true

def current_user
	if session[:user_id]
		User.find(session[:user_id])
	else
		nil
	end
end

get '/' do 
	erb :index
end

get '/login' do
	erb :index
end

post '/sessions' do
	user = User.find_by(username: params[:username])
	if user and user.password == params["password"]
		session[:user_id] = user.id
		flash[:notice] = "Logged In!"
		redirect to '/welcome'
	else 
		flash[:notice] = "There was a problem logging in!"
		redirect to '/login'
	end
end

get '/logout' do
	session[:user_id] = nil
	flash[:notice] = "Logged Out! See you soon!"
	redirect to '/login'
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
	@user = current_user
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
	@user = current_user
	@post = Post.create(user_id: params["current_user"])
	erb :welcome
end

get '/allusers' do
	@users = User.all
	@posts = Post.all
	erb :allusers
end