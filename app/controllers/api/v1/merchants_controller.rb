class Api::V1::MerchantsController < ApplicationController
  def index
    merchants = Merchant.select_records(params[:per_page], params[:page])
    render json: MerchantSerializer.new(merchants)
  end
 
  def show
    merchant = if params[:item_id]
                 Item.find(params[:item_id]).merchant
               else
                 Merchant.find(params[:id])
               end
    render json: MerchantSerializer.new(merchant)
  end

  def find
    merchant = Merchant.find_one_by_name(params[:name])
    render json: (merchant ? MerchantSerializer.new(merchant) : { data: {} })
  end

  def find_all
    merchants = Merchant.find_all_by_name(params[:name])
    render json: MerchantSerializer.new(merchants)
  end

  def most_items
    if params[:quantity].to_i <= 0
      render_invalid_parameters
    else
      merchants = Merchant.select_by_item_sales(params[:quantity])
      render json: MerchantSalesSerializer.new(merchants)
    end
  end
end
