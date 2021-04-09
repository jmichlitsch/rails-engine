require 'rails_helper'

RSpec.describe 'find items by revenue' do
  before(:each) do
    11.times do |n|
      item = create(:item, unit_price: 1.0)
      invoice = create(:invoice, status: 'shipped')
      create(:invoice_item, item: item, invoice: invoice, unit_price: 1.0, quantity: n + 1)
      create(:transaction, invoice: invoice, result: 'success')
    end
  end

  it 'returns a quantity of items ranked by descending revenue' do
    get "/api/v1/revenue/items?quantity=5"

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items).to be_a(Hash)
    check_hash_structure(items, :data, Array)
    expect(items[:data].count).to eq(5)

    items[:data].each do |item|
      expect(item).to be_a(Hash)
      check_hash_structure(item, :id, String)
      check_hash_structure(item, :type, String)
      expect(item[:type]).to eq('item_revenue')
      check_hash_structure(item, :attributes, Hash)
      check_hash_structure(item[:attributes], :name, String)
      check_hash_structure(item[:attributes], :description, String)
      check_hash_structure(item[:attributes], :unit_price, Float)
      check_hash_structure(item[:attributes], :merchant_id, Integer)
      check_hash_structure(item[:attributes], :revenue, Float)
      expect(item.keys).to match_array(%i[id type attributes])
      expect(item[:attributes].keys).to match_array(%i[name description unit_price merchant_id revenue])
    end
  end

  it 'returns 10 items if a quantity is not specified' do
    get "/api/v1/revenue/items"

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(10)
  end

  it 'returns an error if the quantity is not an integer' do
    get "/api/v1/revenue/items?quantity=string"

    expect(response.status).to eq(400)
  end

  it 'returns an error if the quantity is less than 0' do
    get "/api/v1/revenue/items?quantity=-5"

    expect(response.status).to eq(400)
  end

  it 'returns an error if the quantity is blank' do
    get "/api/v1/revenue/items?quantity="

    expect(response.status).to eq(400)
  end
end
