FactoryBot.define do
  factory :transaction do
    invoice
    credit_card_number { Faker::Finance.credit_card }
    credit_card_expiration_date { "1/99" }
    result { [:success, :failed, :refunded].sample }
  end
end
