class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice

  def self.total_revenue_by_date(start, end_date)
    where(invoices: { created_at: Date.parse(start)..Date.parse(end_date).end_of_day }).total_revenue
  end

  def self.total_revenue
    joins(:invoice)
      .merge(Invoice.completed)
      .sum('quantity * invoice_items.unit_price')
  end
end
