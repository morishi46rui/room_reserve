Rails.configuration.stripe = {
  #ご自分の公開可能キーとシークレットキーを入れて下さい
  :publishable_key => 'pk_test_51MIYw1BoYbGcUEuqIJvbcnAKFLZZdxGYYZaLvXc1EbaRE9DETMbVM2m6Oh74EX0i39JHM1Ov5Tpocr4sOfeXtIx700LGxznJXS',
  :secret_key => 'sk_test_51MIYw1BoYbGcUEuqtjSTg6JjcjRgcrXruS2fgWyJlCaLQwHBcGSQ6AGlR1Nx3Fw0vq516R4bSwhTs2ZKExl7e2ap006va0psUx'
}
Stripe.api_key = Rails.configuration.stripe[:secret_key]
Stripe.api_version = '2022-11-15'