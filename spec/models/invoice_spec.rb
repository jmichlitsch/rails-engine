require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it { should belong_to :customer }
    it { should belong_to :merchant }
    it { should have_many(:invoice_items).dependent(:destroy) }
    it { should have_many(:transactions).dependent(:destroy) }
  end

  describe 'class methods' do
    describe '.single_item_invoices' do
      it 'finds invoices that have only one item using an item id' do
        item_id = create(:item).id
        invoice_with_item = create(:invoice)
        create(:invoice_item, invoice: invoice_with_item, item_id: item_id)
        invoice_with_multiple_items = create(:invoice)
        create(:invoice_item, invoice: invoice_with_multiple_items, item_id: item_id)
        create(:invoice_item, invoice: invoice_with_multiple_items, item: create(:item))
        invoice_without_item = create(:invoice)
        create(:invoice_item, invoice: invoice_without_item, item: create(:item))

        expect(Invoice.single_item_invoices(item_id)).to eq([invoice_with_item])
      end
    end

    describe '.unshipped_orders' do
      before(:each) do
        11.times do |n|
          invoice = create(:invoice, status: 'packaged')
          create(:invoice_item, invoice: invoice, unit_price: 1.0, quantity: n + 1)
          create(:transaction, invoice: invoice, result: 'success')
        end
      end

      it 'selects a specified quantity of invoices ranked by potential revenue' do
        orders = Invoice.unshipped_orders(5)

        expect(orders.to_a.size).to eq(5)
        expect(orders[0].potential_revenue).to eq(11.0)
        expect(orders[1].potential_revenue).to eq(10.0)
        expect(orders[2].potential_revenue).to eq(9.0)
        expect(orders[3].potential_revenue).to eq(8.0)
        expect(orders[4].potential_revenue).to eq(7.0)
      end

      it 'returns 10 invoices if no quantity is specified' do
        orders = Invoice.unshipped_orders(nil)

        expect(orders.to_a.size).to eq(10)
      end
    end

    describe '.weekly_revenue' do
      it 'calculates revenue by week' do
        28.times do |n|
          create(:complete_invoice, created_at: "2021-02-#{sprintf('%02d', n + 1)}", revenue: n + 1)
        end

        totals = Invoice.weekly_revenue

        expect(totals.to_a.size).to eq(4)
        expect(totals[0].week).to eq("2021-02-01 00:00:00 UTC")
        expect(totals[0].revenue).to eq(28.0)
        expect(totals[1].week).to eq("2021-02-08 00:00:00 UTC")
        expect(totals[1].revenue).to eq(77.0)
        expect(totals[2].week).to eq("2021-02-15 00:00:00 UTC")
        expect(totals[2].revenue).to eq(126.0)
        expect(totals[3].week).to eq("2021-02-22 00:00:00 UTC")
        expect(totals[3].revenue).to eq(175.0)
      end
    end
  end
end
