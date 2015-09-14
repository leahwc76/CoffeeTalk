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

get '/signup' do
	erb :signup
end

post '/signup' do
	user = User.create(fname: params["fname"], 
		lname: params["lname"], 
		phone: params["phone"],
		email: params["email"],
		username: params["username"],
		password: params["password"])
	session[:user_id] = user.id
	redirect to '/home_post'
end

get '/' do 
	erb :login
end

get '/login' do
	erb :login
end

post '/sessions' do
	user = User.find_by(username: params[:username])
	if user and user.password == params["password"]
		session[:user_id] = user.id
		flash[:notice] = "Logged In!"
		redirect to '/home_post'
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

get '/home_post' do
	@user = current_user
	erb :home_post
end

post '/post' do
    Post.create(title: params["title"],
        body: params["body"],
        user_id: current_user.id
        )
    redirect to '/home_post'
end

get '/create' do
	@user = current_user
	erb :create
end

post '/profile' do
	Profile.create(age: params["age"], 
		city: params["city"], 
		occupation: params["occupation"],
	    user_id: current_user.id
		)
	   redirect to '/create'
end

get '/show' do
	@user = current_user
	@profiles = Profile.all
	profile = Profile.find_by(user_id: current_user.id)
	if profile == nil
		flash[:notice] = "Please Create a Profile!"
		redirect to '/create'
	end
	erb :show
end

get '/edit' do
	@user = current_user
	erb :edit
end

post '/profile/edit' do
	current_user.update(params[:user])
	flash[:notice] = "Profile Updated"
	redirect to '/edit'
end

get '/delete' do
	erb :delete
end

post '/edit/delete' do
	@user = current_user
	current_user.destroy
	session[:user_id] = nil
	flash[:notice] = "Account Deleted"
	redirect to '/signup'
end

get '/explore' do
	@user = current_user
	@users = User.all
	@posts = Post.all
	@relationships = Relationship.all
	erb :explore
end

get '/users/:id' do
	begin
		@user = User.find(params[:id])
		erb :show
	rescue
		flash[:notice] = "That user does not exist."
		redirect to "/explore"
	end
end

get '/follow/:id' do
	@relationship = Relationship.create(follower_id: current_user.id, 
										followed_id: params[:id])
	flash[:notice] = "Followed!"
	redirect to '/explore'
end

get '/unfollow/:id' do
	@relationship = Relationship.find_by(follower_id: current_user.id,
										followed_id: params[:id])
	@relationship.destroy
	flash[:notice] = "Unfollowed!"
	redirect to '/explore'
end