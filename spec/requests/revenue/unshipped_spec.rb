require 'rails_helper'

RSpec.describe 'unshipped items' do
  before(:each) do
    11.times do
      invoice = create(:invoice, status: 'packaged')
      create(:invoice_item, invoice: invoice)
      create(:transaction, invoice: invoice, result: 'success')
    end
  end

  it 'returns the potential revenue of a qunatity of unshipped orders' do
    get "/api/v1/revenue/unshipped?quantity=5"

    expect(response).to be_successful

    orders = JSON.parse(response.body, symbolize_names: true)

    expect(orders).to be_a(Hash)
    check_hash_structure(orders, :data, Array)
    expect(orders[:data].count).to eq(5)

    orders[:data].each do |order|
      expect(order).to be_a(Hash)
      check_hash_structure(order, :id, String)
      check_hash_structure(order, :type, String)
      expect(order[:type]).to eq('unshipped_order')
      check_hash_structure(order, :attributes, Hash)
      check_hash_structure(order[:attributes], :potential_revenue, Float)
      expect(order.keys).to match_array(%i[id type attributes])
      expect(order[:attributes].keys).to match_array(%i[potential_revenue])
    end
  end

  it 'returns 10 orders if a quantity is not specified' do
    get "/api/v1/revenue/unshipped"

    expect(response).to be_successful

    orders = JSON.parse(response.body, symbolize_names: true)

    expect(orders[:data].count).to eq(10)
  end

  it 'returns an error if the quantity is not an integer' do
    get "/api/v1/revenue/unshipped?quantity=string"

    expect(response.status).to eq(400)
  end

  it 'returns an error if the quantity is less than 0' do
    get "/api/v1/revenue/unshipped?quantity=-5"

    expect(response.status).to eq(400)
  end

  it 'returns an error if the quantity is blank' do
    get "/api/v1/revenue/unshipped?quantity="

    expect(response.status).to eq(400)
  end
end
