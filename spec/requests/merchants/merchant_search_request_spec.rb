require 'rails_helper'

RSpec.describe 'merchant search' do
  describe 'find one' do
    it 'returns a single merchant' do
      create(:merchant, name: "Ring World")

      get "/api/v1/merchants/find?name=ring"

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

    it 'returns an empty hash if no merchant is not found' do
      create(:merchant)

      get "/api/v1/merchants/find?name=NOMATCH"

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant).to be_a(Hash)
      check_hash_structure(merchant, :data, Hash)
      expect(merchant[:data]).to be_empty
    end

    it 'returns an empty hash if no query string is provided' do
      get "/api/v1/merchants/find"

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant).to be_a(Hash)
      check_hash_structure(merchant, :data, Hash)
      expect(merchant[:data]).to be_empty
    end
  end

  describe 'find all' do
    it 'returns a collection of merchants using a search term' do
      crafts = [create(:merchant, name: "Handicraft World"),
                create(:merchant, name: "The Craft Guy")]
      ring_world = create(:merchant, name: "Ring World")

      get "/api/v1/merchants/find_all?name=craft"

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants).to be_a(Hash)
      check_hash_structure(merchants, :data, Array)
      expect(merchants[:data].count).to eq(2)

      merchants[:data].each do |merchant|
        expect(merchant).to be_a(Hash)
        check_hash_structure(merchant, :id, String)
        check_hash_structure(merchant, :type, String)
        expect(merchant[:type]).to eq('merchant')
        check_hash_structure(merchant, :attributes, Hash)
        check_hash_structure(merchant[:attributes], :name, String)
        expect(merchant.keys).to match_array(%i[id type attributes])
        expect(merchant[:attributes].keys).to match_array(%i[name])
      end
    end

    it 'returns an empty array if no merchant is not found' do
      create(:merchant)

      get "/api/v1/merchants/find_all?name=NOMATCH"

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants).to be_a(Hash)
      check_hash_structure(merchants, :data, Array)
      expect(merchants[:data]).to be_empty
    end

    it 'returns an empty array if no query string is provided' do
      create(:merchant)

      get "/api/v1/merchants/find_all"

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant).to be_a(Hash)
      check_hash_structure(merchant, :data, Array)
      expect(merchant[:data]).to be_empty
    end

    it 'returns a single merchant in an array if only one result is found' do
      ring_world = create(:merchant, name: "Ring World")

      get "/api/v1/merchants/find_all?name=ring"

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant).to be_a(Hash)
      check_hash_structure(merchant, :data, Array)
      expect(merchant[:data].count).to eq(1)
    end
  end
end
