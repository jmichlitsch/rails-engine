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

      it 'gets merchants when passed a page number' do
        create_list(:merchant, 21)

        selected = Merchant.select_records(nil, 2)
        expect(selected.count).to eq(1)
      end

      it 'gets merchants using a per_page limit' do
        create_list(:merchant, 3)

        selected = Merchant.select_records(2, nil)
        expect(selected.to_a.size).to eq(2)
      end

      it 'gets merchants using both a page number and a per_page limit' do
        create_list(:merchant, 3)

        selected = Merchant.select_records(2, 2)
        expect(selected.to_a.size).to eq(1)
      end
    end

    describe '.find_one_by_name' do
      it 'finds a merchant using a search term' do
        merchant = create(:merchant, name: "Ring World")
        create(:merchant, name: "Bob's Burgers")

        expect(Merchant.find_one_by_name('ring')).to eq(merchant)
      end

      it 'returns the first merchant in the database in case-sensitive alphabetical order if multiple matches are found' do
        turing = create(:merchant, name: "Turing")
        annies_rings = create(:merchant, name: "Annie's Rings")
        ring_world = create(:merchant, name: "ring world")

        expect(Merchant.find_one_by_name('ring')).to eq(annies_rings)
      end
    end

    describe '.find_all_by_name' do
      it 'finds a group of merchants using a search term' do
        crafts = [create(:merchant, name: "Handicraft World"),
                  create(:merchant, name: "The Craft Guy")]
        ring_world = create(:merchant, name: "Ring World")

        expect(Merchant.find_all_by_name('craft')).to match_array(crafts)
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

  describe 'instance methods' do
    describe '#total_revenue' do
      it 'returns the merchant with their total revenue' do
        merchant = create(:merchant)
        5.times do |n|
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

        result = merchant.total_revenue
        expect(merchant.total_revenue).to eq(5)
      end
    end
  end
end
