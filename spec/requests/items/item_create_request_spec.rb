require 'rails_helper'

RSpec.describe 'create an item' do
  it 'creates a new item' do
    merchant_id = create(:merchant).id
    item_params = attributes_for(:item).merge(merchant_id: merchant_id)
    headers = {'CONTENT_TYPE' => 'application/json'}

    post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

    created_item = Item.last

    expect(response).to be_successful
    expect(response.status).to eq(201)
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])

    item = JSON.parse(response.body, symbolize_names: true)

    expect(item).to be_a(Hash)
    check_hash_structure(item, :data, Hash)
    check_hash_structure(item[:data], :id, String)
    check_hash_structure(item[:data], :type, String)
    check_hash_structure(item[:data], :attributes, Hash)
    check_hash_structure(item[:data][:attributes], :name, String)
    check_hash_structure(item[:data][:attributes], :description, String)
    check_hash_structure(item[:data][:attributes], :unit_price, Float)
    check_hash_structure(item[:data][:attributes], :merchant_id, Integer)
    expect(item[:data].keys).to match_array(%i[id type attributes])
    expect(item[:data][:attributes].keys).to match_array(%i[name description unit_price merchant_id])
  end
end
