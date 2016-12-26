class UsersController < ApplicationController

  def index
    @sandbox_users = User.sandbox.all
    @users = User.all
  end

  def show
    @user = User.find params[:id]
    @locations = @user.locations.includes(:transactions)    
  end

  def update
    @user = User.find params[:id]
    @user.update(user_params)
    redirect_to user_path(@user)
  end

  def charge
    api = SquareConnect::TransactionApi.new
    idempotency_key = SecureRandom.uuid
    u = User.find params[:id]
    charge_body = {
      idempotency_key: idempotency_key, 
      amount_money: {amount: nonce_params[:amount].to_i, currency: 'USD'}, 
      card_nonce: nonce_params[:nonce]
    }.to_json
    a = api.charge(u.token, u.locations.first.square_id, charge_body)
  end

  private

  def user_params
    params.require(:user).permit(:state)
  end

  def nonce_params
    params.permit(:nonce, :amount)
  end

end