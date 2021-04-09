require 'rails_helper'

RSpec.describe "get all items for a merchant" do
  it 'gets all items associated with a merchant' do
    merchant = create(:merchant)
    create_list(:item, 21, merchant: merchant)

    get "/api/v1/merchants/#{merchant.id}/items"

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items).to be_a(Hash)
    check_hash_structure(items, :data, Array)
    expect(items[:data].count).to eq(21)

    items[:data].each do |item|
      expect(item).to be_a(Hash)
      check_hash_structure(item, :id, String)
      check_hash_structure(item, :type, String)
      check_hash_structure(item, :attributes, Hash)
      check_hash_structure(item[:attributes], :name, String)
      check_hash_structure(item[:attributes], :description, String)
      check_hash_structure(item[:attributes], :unit_price, Float)
      check_hash_structure(item[:attributes], :merchant_id, Integer)
      expect(item.keys).to match_array(%i[id type attributes])
      expect(item[:attributes].keys).to match_array(%i[name description unit_price merchant_id])
    end
  end

  it 'returns an empty array if the merchant has no items' do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}/items"

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data]).to be_an(Array)
    expect(items[:data].count).to eq(0)
  end

  it 'returns a 404 if merchant is not found' do
    get "/api/v1/merchants/1/items"

    expect(response.status).to eq(404)

    get "/api/v1/merchants/one/items"

    expect(response.status).to eq(404)
  end
end
