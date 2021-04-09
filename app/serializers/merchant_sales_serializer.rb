class MerchantRevenueSerializer
  include FastJsonapi::ObjectSerializer
  set_type :merchant_revenue
  attribute :revenue, &:total_revenue
end
