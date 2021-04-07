class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items
  def self.select_merchants(per_page, page)
    results = (per_page || 20).to_i
    skipped_pages = (page || 1).to_i - 1
    Merchant.limit(results).offset(results * skipped_pages)
  end
end
