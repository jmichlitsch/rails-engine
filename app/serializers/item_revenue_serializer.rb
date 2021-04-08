class ItemRevenueSerializer < ItemSerializer
  include FastJsonapi::ObjectSerializer
  set_type :item_revenue
  attribute :revenue
end
