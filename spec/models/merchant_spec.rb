require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
   it { should have_many :items }
   it { should have_many(:invoice_items).through(:items) }
 end
 describe 'class methods' do
   describe '.select_records' do
    it 'gets the first 20 merchants by default' do
      create_list(:merchant, 21)

      selected = Merchant.select_records(nil, nil)
      expect(selected.to_a.size).to eq(20)
    end
   end

  describe '.find_one_by_name' do
    it 'finds a merchant using a search term' do
      merchant = create(:merchant, name: "Ring World")
      create(:merchant, name: "Bob's Burgers")

      expect(Merchant.find_one_by_name('ring')).to eq(merchant)
    end
  end

  describe '.top_merchants' do
      before(:each) do
        6.times do |n|
          merchant = create(:merchant)
          (n + 1).times do
            item = create(:item, merchant: merchant)
            invoice = create(:invoice, merchant: merchant, status: 'shipped')
            create(:invoice_item, invoice: invoice, item: item, unit_price: 1.0, quantity: 1)
            create(:transaction, invoice: invoice, result: 'success')
          end
        end
      end

      it 'finds a specified quantity of merchants' do
        merchants = Merchant.top_merchants(5)

        expect(merchants.to_a.size).to eq(5)
        expect(merchants[0].revenue).to eq(6)
        expect(merchants[1].revenue).to eq(5)
        expect(merchants[2].revenue).to eq(4)
        expect(merchants[3].revenue).to eq(3)
        expect(merchants[4].revenue).to eq(2)
      end

      it 'can find a different quantity of merchants' do
        merchants = Merchant.top_merchants(2)

        expect(merchants.to_a.size).to eq(2)
        expect(merchants[0].revenue).to eq(6)
        expect(merchants[1].revenue).to eq(5)
      end
    end
    describe '.select_by_item_sales' do
      before(:each) do
        8.times do |n|
          merchant = create(:merchant)
          (n + 1).times do
            item = create(:item, merchant: merchant)
            invoice = create(:invoice, merchant: merchant, status: 'shipped')
            create(:invoice_item, invoice: invoice, item: item, unit_price: 1.0, quantity: n + 1)
            create(:transaction, invoice: invoice, result: 'success')
          end
        end
      end

      it 'finds a specified quantity of merchants' do
        merchants = Merchant.select_by_item_sales(7)

        expect(merchants.to_a.size).to eq(7)
        expect(merchants[0].sales_count).to eq(64)
        expect(merchants[1].sales_count).to eq(49)
        expect(merchants[2].sales_count).to eq(36)
        expect(merchants[3].sales_count).to eq(25)
        expect(merchants[4].sales_count).to eq(16)
        expect(merchants[5].sales_count).to eq(9)
        expect(merchants[6].sales_count).to eq(4)
      end

      it 'can find a different quantity of merchants' do
        merchants = Merchant.select_by_item_sales(3)

        expect(merchants.to_a.size).to eq(3)
      end
    end
  end
end
