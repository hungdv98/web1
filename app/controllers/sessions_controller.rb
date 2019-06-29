class SessionsController < ApplicationController
  def new
  end

  def create
    if params[:session].present?
      user = User.find_by email: params[:session][:email].downcase
      if user && user.authenticate(params[:session][:password]) &&
      user.activated == true && user.status == true
       log_in user
       user.last_login = DateTime.now
       user.save
       params[:session][:remember_me] == "1" ? remember(user) : forget(user)
       redirect_back_or user
      else
       if user == nil
         flash.now[:danger] = t "controllers.sessions.not_found_account"
         render :new
       elsif user.activated == false
         flash.now[:danger] = t "controllers.sessions.not_active"
       else
         flash.now[:danger] = t "controllers.sessions.wrong_user_pass"
         render :new
       end
      end
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to login_url
  end

  def remember user
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def failure
    render :text => "not allowd to access app"
  end

  def receive
  end
end