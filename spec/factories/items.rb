FactoryBot.define do
  factory :item do
    merchant
    name { Faker::Commerce.product_name }
    description { Faker::Hipster.paragraph }
    unit_price { Faker::Commerce.price(range: 0.01..1000) }
  end
end
