require 'rails_helper'

RSpec.describe 'find merchants by item quantity sold' do
  before(:each) do
    8.times do |n|
      merchant = create(:merchant)
      (n + 1).times do
        item = create(:item, merchant: merchant)
        invoice = create(:invoice, merchant: merchant, status: 'shipped')
        create(:invoice_item, invoice: invoice, item: item, unit_price: 1.0, quantity: 1)
        create(:transaction, invoice: invoice, result: 'success')
      end
    end
  end

  it 'returns a quantity of merchants ranked by total items sold' do
    get "/api/v1/merchants/most_items?quantity=7"

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants).to be_a(Hash)
    check_hash_structure(merchants, :data, Array)
    expect(merchants[:data].count).to eq(7)

    merchants[:data].each do |merchant|
      expect(merchant).to be_a(Hash)
      check_hash_structure(merchant, :id, String)
      check_hash_structure(merchant, :type, String)
      expect(merchant[:type]).to eq('items_sold')
      check_hash_structure(merchant, :attributes, Hash)
      check_hash_structure(merchant[:attributes], :name, String)
      check_hash_structure(merchant[:attributes], :count, Integer)
      expect(merchant.keys).to match_array(%i[id type attributes])
      expect(merchant[:attributes].keys).to match_array(%i[name count])
    end
  end

  it 'returns an error if the quantity is not specified' do
    get "/api/v1/merchants/most_items"

    expect(response.status).to eq(400)
  end

  it 'can return less than 5 merchants' do
    get "/api/v1/merchants/most_items?quantity=2"

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(2)
  end

  it 'returns an error if the quantity is not an integer' do
    get "/api/v1/merchants/most_items?quantity=string"

    expect(response.status).to eq(400)
  end

  it 'returns an error if the quantity is less than 0' do
    get "/api/v1/merchants/most_items?quantity=-5"

    expect(response.status).to eq(400)
  end

  it 'returns an error if the quantity is blank' do
    get "/api/v1/merchants/most_items?quantity="

    expect(response.status).to eq(400)
  end
end
