require 'rails_helper'

RSpec.describe 'get one merchant' do
  it 'returns a single record by id' do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

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

  it 'returns a 404 if record does not exist' do
    get "/api/v1/merchants/1"

    expect(response.status).to eq(404)
  end

  it 'returns a 404 if a non-integer is entered' do
    get "/api/v1/merchants/one"

    expect(response.status).to eq(404)
  end
end
