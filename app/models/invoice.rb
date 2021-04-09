class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :transactions, dependent: :destroy

  scope :completed, -> { joins(:transactions).merge(Transaction.successful).where(status: :shipped) }

  def self.single_item_invoices(item_id)
    joins(:invoice_items).group(:id).having("'{#{item_id}}' = (ARRAY_AGG(DISTINCT item_id))")
  end

  def self.unshipped_orders(quantity)
    select('invoices.*, SUM(quantity * unit_price) AS potential_revenue')
      .joins(:invoice_items, :transactions)
      .where(status: :packaged)
      .merge(Transaction.successful)
      .group(:id)
      .order('potential_revenue' => :desc)
      .limit(quantity || 10)
  end

  def self.weekly_revenue
    completed.select("DATE_TRUNC('week', invoices.created_at) week, SUM(quantity * unit_price) revenue")
             .joins(:invoice_items)
             .group(:week)
             .order(:week)
  end
end
