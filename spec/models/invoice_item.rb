require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'relationships' do
    it { should belong_to :item }
    it { should belong_to :invoice }
  end

  describe 'class methods' do
    it '.total_revenue_by_date' do
    #   #complete invoices have a transaction that is successful unless specified otherwise and a revenue of 1.00
      create(:complete_invoice, status: 'shipped', created_at: '2012-03-09')
      create(:complete_invoice, status: 'shipped', created_at: '2012-03-10')
      create(:complete_invoice, status: 'shipped', created_at: '2012-03-11')

      create(:complete_invoice, status: 'shipped', created_at: '2012-03-08')
      create(:complete_invoice, status: 'shipped', created_at: '2012-03-12')
      create(:complete_invoice, status: 'returned', created_at: '2012-03-10')
      create(:complete_invoice, status: 'packaged', created_at: '2012-03-10')
      create(:complete_invoice, result: 'refunded', status: 'shipped', created_at: '2012-03-10')
      create(:complete_invoice, result: 'failed', status: 'shipped', created_at: '2012-03-10')

      expect(InvoiceItem.total_revenue_by_date('2012-03-09', '2012-03-11')).to eq(3.0)
    end

    describe '.total_revenue' do
      it 'returns the total revenue for successful invoices' do
        merchant = create(:merchant)
        5.times do
          item = create(:item, merchant: merchant)
          invoice = create(:invoice, merchant: merchant, status: 'shipped')
          create(:invoice_item, invoice: invoice, item: item, unit_price: 1.0, quantity: 1)
          create(:transaction, invoice: invoice, result: 'success')
        end

        item = create(:item, merchant: merchant)
        invoice = create(:invoice, merchant: merchant, status: 'shipped')
        create(:invoice_item, invoice: invoice, item: item, unit_price: 1.0, quantity: 10)
        create(:transaction, invoice: invoice, result: 'failed')

        item = create(:item, merchant: merchant)
        invoice = create(:invoice, merchant: merchant, status: 'packaged')
        create(:invoice_item, invoice: invoice, item: item, unit_price: 1.0, quantity: 10)
        create(:transaction, invoice: invoice, result: 'success')

        expect(InvoiceItem.total_revenue).to eq(5)
      end
    end
  end
end
