class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items

  delegate :total_revenue, to: :invoice_items

  def self.top_merchants(quantity)
    select('merchants.*, SUM(quantity * invoice_items.unit_price) revenue')
      .joins(items: { invoice_items: :invoice })
      .merge(Invoice.completed)
      .group(:id)
      .order(revenue: :desc)
      .limit(quantity)
  end

  def self.select_by_item_sales(quantity)
    select('merchants.*, SUM(quantity) sales_count')
      .joins(items: { invoice_items: :invoice })
      .merge(Invoice.completed)
      .group(:id)
      .order(sales_count: :desc)
      .limit(quantity)
  end
end
