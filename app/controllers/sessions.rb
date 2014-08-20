get '/sessions/new' do 
	erb :"sessions/new"
end

post '/sessions' do 
	email, password = params[:email], params[:password]
	user = User.authenticate(email, password)
	if user
		session[:user_id] = user.id
		redirect '/'
	else
		flash[:errors] = ["The email or password is incorrect"]
		erb :"sessions/new"
	end
end

delete '/sessions' do 
	flash[:notice] = "Good bye!"
	session[:user_id] = nil
	redirect '/'
end

post "/sessions/forgotten" do 
	user = User.first(email: params[:femail])
	user.password_token = (1..64).map{("A".."Z").to_a.sample}.join
	user.password_token_timestamp = Time.now
	user.save
	redirect '/sessions/forgotten/email-sent'
end

get '/sessions/forgotten/email-sent' do 
	"An email with a unique token has been sent to your account"
end


get "/sessions/reset_password/:token" do 
	@user = User.first(password_token: params[:token])
	if Time.now - @user.password_token_timestamp <= (3600)
		erb :reset_password
	else
		"You have taken too long to reset your password"
	end
end

post "/sessions/reset_password/:token/new_password" do 
	user = User.first(password_token: params[:token])
	user.password = params[:reset_password]
	user.password_token = nil
	user.save
	redirect '/'
end
