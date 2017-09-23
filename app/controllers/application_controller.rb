require "./config/environment"
require "./app/models/user"
require 'pry'

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
    # here we will create user and password in the table if they both exist
    # otherwise re-direct to failure page
    # could check for duplicate username
    # this seems inelegant... want to see how others do it
    if params[:username] != "" && params[:password] != ""
      @new_user = User.create(username: params[:username], password: params[:password])
      redirect to '/login'
    else
      redirect to '/failure'
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
    ## we want to set the session hash if we have been given data to set it with
    ## otherwise we want to redirect to the failure route
    ## your code here
    if params[:username] != "" && params[:password] != ""
      @new_user = User.find_by(username: params[:username], password: params[:password])
      session[:user_id] = @new_user.id
      redirect to '/account'
    else
      redirect to '/failure'
    end

  end

  get "/success" do
    if logged_in?
      erb :success
    else
      redirect "/login"
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
