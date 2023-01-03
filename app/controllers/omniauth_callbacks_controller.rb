class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def stripe_connect
    auth_data = request.env["omniauth.auth"]
    @user = current_user
    if @user.persisted?
      @user.merchant_id = auth_data.uid
      @user.save
      if !@user.merchant_id.blank?
        # 支払いスケジュールを更新する
        account = Stripe::Account.retrieve(current_user.merchant_id)
        # 決算の15日後にお支払い  
        account.settings.payouts.schedule.delay_days = 15
        account.save
        logger.debug "#{account}"
      end
      sign_in_and_redirect @user, event: :authentication
      flash[:notice] = "ストライプアカウントを作成し接続しました。" if is_navigational_format?
    else
      session["devise.stripe_connect_data"] = request.env["omniauth.auth"]
      redirect_to dashboard_path
    end
  end 

  def failure
    redirect_to root_path
  end

end