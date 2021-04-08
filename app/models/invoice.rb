class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :transactions, dependent: :destroy
  scope :completed, -> { joins(:transactions).merge(Transaction.successful).where(status: :shipped) }

  def self.single_item_invoices(item_id)
    joins(:invoice_items).group(:id).having("'{#{item_id}}' = (ARRAY_AGG(DISTINCT item_id))")
  end
end
