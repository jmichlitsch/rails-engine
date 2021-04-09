require 'rails_helper'

RSpec.describe 'get a merchant by item id' do
  it 'gets the merchant of an item' do
    id = create(:item).id

    get "/api/v1/items/#{id}/merchant"

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant).to be_a(Hash)
    check_hash_structure(merchant, :data, Hash)
    check_hash_structure(merchant[:data], :id, String)
    check_hash_structure(merchant[:data], :type, String)
    check_hash_structure(merchant[:data], :attributes, Hash)
    check_hash_structure(merchant[:data][:attributes], :name, String)
    expect(merchant[:data].keys).to match_array(%i[id type attributes])
    expect(merchant[:data][:attributes].keys).to match_array(%i[name])
  end

  it 'returns a 404 if item is not found' do
    get "/api/v1/items/1/merchant"

    expect(response.status).to eq(404)

    get "/api/v1/items/one/merchant"

    expect(response.status).to eq(404)
  end
end
