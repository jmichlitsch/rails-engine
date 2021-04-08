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

  def create
    item = Item.create!(item_params)
    render json: ItemSerializer.new(item), status: :created
  end

  def update
      item = Item.find(params[:id])
      item.update!(item_params)
      render json: ItemSerializer.new(item)
    end

  def destroy
    Item.find(params[:id]).destroy
  end

  def find
  if params[:name] && (params[:min_price] || params[:max_price])
    render_invalid_parameters
  elsif params[:name]
    item = Item.find_one_by_name(params[:name])
    render json: (item ? ItemSerializer.new(item) : { data: {} })
  else
    item = Item.find_one_by_price(params[:min_price], params[:max_price])
    render json: (item ? ItemSerializer.new(item) : { data: {} })
  end
end

def find_all
  if params[:name] && (params[:min_price] || params[:max_price])
    render_invalid_parameters
  elsif params[:name]
    items = Item.find_all_by_name(params[:name])
    render json: ItemSerializer.new(items)
  else
    items = Item.find_all_by_price(params[:min_price], params[:max_price])
    render json: ItemSerializer.new(items)
  end
end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
