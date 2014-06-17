require 'data_mapper'
require 'sinatra'

env = ENV["RACK_ENV"] || "development"

DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")

require './lib/link'
require './lib/tag'
require './lib/user'

DataMapper.finalize
DataMapper.auto_upgrade!

helpers do 
	def current_user
		@current_user ||= User.get(session[:user_id]) if session[:user_id]
	end
end


get '/' do 
	@links = Link.all
	erb :index
end

post '/links' do 
	url = params[:url]
	title = params[:title]
	tags = params[:tags].split(" ").map { |tag| Tag.first_or_create(text: tag)}
	Link.create(url: url, title: title, tags: tags)
	redirect '/'
end

get '/tags/:text' do 
	tag = Tag.first(text: params[:text])
	@links = tag ? tag.links : []
	erb :index
end

get '/users/new' do 
	erb :"users/new"
end

enable :sessions
set :session_secret, 'super secret'

post '/users' do 
	user = User.create(email: params[:email],
		password: params[:password])
	session[:user_id] = user.id
	redirect '/'
end
