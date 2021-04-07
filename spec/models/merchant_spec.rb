require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
   it { should have_many :items }
   it { should have_many(:invoice_items).through(:items) }
 end
 describe 'class methods' do
   describe '.select_merchants' do
     it 'gets the first 20 merchants by default' do
       create_list(:merchant, 21)

       selected = Merchant.select_merchants(nil, nil)
       expect(selected).to eq(Merchant.first(20))
     end
   end
   describe '.find_one_by_name' do
    it 'finds a merchant using a search term' do
      merchant = create(:merchant, name: "Ring World")
      create(:merchant, name: "Bob's Burgers")

      expect(Merchant.find_one_by_name('ring')).to eq(merchant)
    end
  end
 end
end
