class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items

  def self.top_merchants(quantity)
    select('merchants.*, SUM(quantity * invoice_items.unit_price) revenue')
      .joins(items: { invoice_items: { invoice: :transactions } })
      .where(invoices: { status: :shipped }, transactions: { result: :success })
      .group(:id)
      .order(revenue: :desc)
      .limit(quantity)
  end
end
