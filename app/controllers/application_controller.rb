require "./config/environment"
require "./app/models/user"
class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end

  get "/" do
    erb :index
  end

  get "/signup" do
    erb :signup
  end

  post "/signup" do
    user = User.new(username: params[:username], password_digest: params[:password])
    # binding.pry
    if user.username == "" || user.password_digest == ""
      redirect '/failure'
    else
      User.create(username: user.username, password: user.password)
      redirect '/login'
    end
  end

  get '/account' do
    @user = User.find(session[:user_id])
    erb :account
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    user = User.new(username: params[:username], password_digest: params[:password])
    # binding.pry
    if user.username == "" || user.password_digest == ""
      redirect '/failure'
    else
      new_user = User.create(username: user.username, password_digest: user.password_digest)
      session[:user_id] = new_user.id
      redirect '/account'
    end
  end

  get "/failure" do
    erb :failure
  end

  get "/logout" do
    session.clear
    redirect "/"
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end
