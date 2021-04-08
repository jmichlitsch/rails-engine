class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  validates :name, :description, :unit_price, presence: true

  before_destroy :destroy_dependent_invoices, prepend: true
  def destroy_dependent_invoices
    Invoice.single_item_invoices(id).destroy_all
  end
end
