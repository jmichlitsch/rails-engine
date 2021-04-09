require 'rails_helper'

RSpec.describe "revenue for a single merchant" do
  before(:each) do
    @id = create(:merchant).id
    5.times do |n|
      item = create(:item, merchant_id: @id)
      invoice = create(:invoice, merchant_id: @id, status: 'shipped')
      create(:invoice_item, invoice: invoice, item: item, unit_price: 1.0, quantity: n + 1)
      create(:transaction, invoice: invoice, result: 'success')
    end
  end

  it 'gets revenue for a single merchant' do
    get "/api/v1/revenue/merchants/#{@id}"

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant).to be_a(Hash)
    check_hash_structure(merchant, :data, Hash)

    check_hash_structure(merchant[:data], :id, String)
    check_hash_structure(merchant[:data], :type, String)
    expect(merchant[:data][:type]).to eq('merchant_revenue')
    check_hash_structure(merchant[:data], :attributes, Hash)
    check_hash_structure(merchant[:data][:attributes], :revenue, Float)
    expect(merchant[:data].keys).to match_array(%i[id type attributes])
    expect(merchant[:data][:attributes].keys).to match_array(%i[revenue])
  end

  it 'returns an error if the merchant does not exist' do
    get "/api/v1/revenue/merchants/9999999"

    expect(response.status).to eq(404)
  end
end
