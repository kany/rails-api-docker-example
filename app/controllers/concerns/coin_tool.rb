module CoinTool
  def load_coin
    @coin = Coin.first_or_create!
  end
end
