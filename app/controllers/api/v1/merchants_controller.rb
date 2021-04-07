class Api::V1::MerchantsController < ApplicationController
  def index
    render json: Merchant.select_merchants(params[:per_page], params[:page])
  end
end
