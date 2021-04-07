class Api::V1::ItemsController < ApplicationController
  def index
    items = if params[:merchant_id]
              Merchant.find(params[:merchant_id]).items
            else
              Item.select_records(params[:per_page], params[:page])
            end
    render json: ItemSerializer.new(items)
  end

  def show
    item = Item.find(params[:id])
    render json: ItemSerializer.new(item)
  end
end
