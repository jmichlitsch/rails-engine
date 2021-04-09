class MerchantNameRevenueSerializer < MerchantSerializer
  include FastJsonapi::ObjectSerializer
  set_type :merchant_name_revenue
  attributes :revenue
end
