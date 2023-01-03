class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def dashboard
  end

  def show
    @user = User.find(params[:id])
    @rooms = @user.rooms
  end

  def update
    @user = current_user
    if @user.update(current_user_params)
      flash[:notice] = "保存しました"
    else
      flash[:alert] = "更新できません"
    end
    redirect_to dashboard_path
  end

  def update_payment
    if !current_user.stripe_id
      customer = Stripe::Customer.create(
        email: current_user.email,
        source: params[:stripeToken]
      )
    else
      customer = Stripe::Customer.update(
        current_user.stripe_id,
        source: params[:stripeToken]
      )
    end
    if current_user.update(stripe_id: customer.id)
      flash[:notice] = "新しいカード情報が登録されました"
    else
      flash[:alert] = "無効なカードです"
    end
    redirect_to request.referrer
  rescue Stripe::CardError => e
    flash[:alert] = e.message
    redirect_to request.referrer
  end

  def payout
    if !current_user.merchant_id.blank?
      account = Stripe::Account.retrieve(current_user.merchant_id)
      @login_link = account.login_links.create()
    end
  end

  
  private
  
  def current_user_params
    params.require(:user).permit(:about, :status, :avatar)
  end

end
