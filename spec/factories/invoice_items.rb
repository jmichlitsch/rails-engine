FactoryBot.define do
  factory :invoice_item do
    item
    invoice
    quantity { Faker::Number.within(range: 1..20) }
    unit_price { Faker::Commerce.price(range: 0.01..1000) }
  end
end
