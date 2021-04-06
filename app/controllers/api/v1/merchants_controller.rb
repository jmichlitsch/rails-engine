class Api::V1::MerchantsController < ApplicationController
  def index
    render json: Merchant.first(20)
  end
end
