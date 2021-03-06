require 'pry'

class UsersController < ApplicationController

  get '/signup' do
    if !Helpers.logged_in?(session)
      erb :"users/create_user"
    else
      redirect to '/tweets'

    end
  end

  post '/signup' do
    if params[:username] == "" || params[:email] == "" || params[:password] == ""
      redirect to '/signup'
    else
      user = User.new(username: params[:username], email: params[:email], password: params[:password])
      if user.save
        session[:user_id] = user.id
        redirect to '/tweets'
      end
    end
  end

  get '/login' do
    if Helpers.logged_in?(session)
      redirect to '/tweets'
    end
    erb :"users/login"
  end

  post '/login' do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect to '/tweets'
    else
      redirect to '/login'
    end
  end

  get '/logout' do
    if Helpers.logged_in?(session)
      session.clear
      redirect to '/login'
    else
      redirect to '/'
    end
  end

  get '/users/:slug' do
    slug = params[:slug]
    @user = User.find_by_slug(slug)
    erb :"users/show"
  end

end

  