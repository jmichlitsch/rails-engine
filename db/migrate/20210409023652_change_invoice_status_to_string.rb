class ChangeInvoiceStatusToString < ActiveRecord::Migration[5.2]
  def change
    change_column :invoices, :status, :string
  end
end
