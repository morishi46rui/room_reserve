module ApplicationHelper
  def avatar_url(user)
    if user.avatar.attached?
      url_for(user.avatar)
    elsif user.image?
      user.image
    else
      ActionController::Base.helpers.asset_path('icon_default_avatar.jpg')
    end
  end  

  # テスト環境のクライアント ID(コネクトのID)　ca_
  def stripe_express_path
    "https://connect.stripe.com/express/oauth/authorize?response_type=code&client_id=ca_N2fNc8KfuHUiBoZTWTAH5VkZ4H7LpNvP&scope=read_write"
  end

end
