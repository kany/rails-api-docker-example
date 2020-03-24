class ItemsController < ApplicationController
  include CoinTool
  before_action :load_coin, only: :update

  def index
    render json: Item.all.as_json
  end

  def update
    @item = Item.find(params['id'])

    raise if @item.quantity.zero?
    raise if @coin.quantity < 2

    if @coin.quantity > @item.price
      @coin.quantity -= @item.price
      @coin.save!
      @item.quantity -= 1
      @item.save!
    end

    response.headers['X-Inventory-Remaining'] = @item.quantity
    render json: { "quantity": "1" }
  rescue
    head :not_found if @item.quantity.zero?
    head :forbidden if @coin.quantity < 2
  ensure
    response.headers['X-Coin'] = @coin.quantity
  end
end
