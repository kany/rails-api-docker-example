class CoinsController < ApplicationController
  include CoinTool
  before_action :load_coin

  def add
    @coin.update_quantity!(params['coin'])
    head :no_content
  rescue
    head :bad_request
  ensure
    response.headers['X-Coin'] = params['coin']
  end

  def remove
    coins_to_remove = @coin.quantity
    @coin.update_attribute(:quantity, 0)

    response.headers['X-Coin'] = coins_to_remove
    head :no_content
  end
end
