class MerchantSalesSerializer < MerchantSerializer
  include FastJsonapi::ObjectSerializer
  set_type :items_sold
  attribute :count, &:sales_count
end
