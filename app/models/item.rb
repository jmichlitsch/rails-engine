class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  validates :name, :description, :unit_price, presence: true

  before_destroy :destroy_dependent_invoices, prepend: true

  def destroy_dependent_invoices
    Invoice.single_item_invoices(id).destroy_all
  end

  def self.find_one_by_price(min_price, max_price)
    find_by('unit_price BETWEEN ? AND ?', (min_price || 0), (max_price || Float::INFINITY))
  end

  def self.find_all_by_price(min_price, max_price)
    where('unit_price BETWEEN ? AND ?', (min_price || 0), (max_price || Float::INFINITY))
  end

  def self.select_items_by_revenue(quantity)
    joins(:invoices)
      .merge(Invoice.completed)
      .select('items.*, SUM(quantity * invoice_items.unit_price) revenue')
      .group(:id)
      .order(revenue: :desc)
      .limit(quantity || 10)
  end
end
