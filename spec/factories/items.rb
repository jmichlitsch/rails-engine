FactoryBot.define do
  factory :item do
    name { "ShamWow" }
    description { "Makes you say Wow everytime" }
    unit_price { 2 }
    merchant { nil }
  end
end
