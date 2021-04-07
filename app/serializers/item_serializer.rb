class ItemSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :description, :unit_price, :merchant_id
end
