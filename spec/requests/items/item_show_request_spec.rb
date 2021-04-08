require 'rails_helper'

RSpec.describe 'get one item' do
  it 'returns a single record by id' do
    id = create(:item).id

    get "/api/v1/items/#{id}"

    expect(response).to be_successful

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
