class Api::V1::MerchantsController < ApplicationController
  def index
    merchants = Merchant.select_records(params[:per_page], params[:page])
    render json: MerchantSerializer.new(merchants)
  end

  def show
    merchant = Merchant.find(params[:id])
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
end
