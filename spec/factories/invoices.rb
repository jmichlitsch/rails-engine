FactoryBot.define do
  factory :invoice do
    customer { nil }
    merchant { nil }
    status { 1 }
  end
end
