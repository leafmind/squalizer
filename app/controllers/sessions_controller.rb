class SessionsController < ApplicationController

  def new
  end

  def create
    @user = User.from_omniauth(auth_hash)
    redirect_to root_path
  end

  def failure
  	flash[:notice] = "OAuth Failure"
    redirect_to root_path
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end