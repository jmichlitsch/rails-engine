require 'rails_helper'

RSpec.describe "Merchants API" do
  describe 'merchants index' do
    it 'sends a list of 20 merchants' do
      create_list(:merchant, 25)

      get '/api/v1/merchants'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants.count).to eq(20)

      merchants.each do |merchant|
        expect(merchant).to be_a(Hash)
        check_structure(merchant, :id, Integer)
        check_structure(merchant, :name, String)
        expect(merchant.keys).to match_array(%i[id name created_at updated_at])
      end
    end
    it 'sends an array of data even if one resource is found' do
      create(:merchant)

      get '/api/v1/merchants'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants).to be_an(Array)
      expect(merchants.count).to eq(1)
    end

    it 'sends an array of data even if zero resources are found' do
      get '/api/v1/merchants'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants).to be_an(Array)
      expect(merchants.count).to eq(0)
    end

    describe 'allows for optional per_page query param' do
      it 'users can request less than the total number of merchants' do
        create_list(:merchant, 3)

        get '/api/v1/merchants?per_page=2'

        expect(response).to be_successful

        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(merchants.count).to eq(2)
        expect(merchants.pluck(:id)).to match_array(Merchant.first(2).pluck(:id))
      end

      it 'users can request more than the total number of merchants' do
        create_list(:merchant, 5)

        get '/api/v1/merchants?per_page=10'

        expect(response).to be_successful

        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(merchants.count).to eq(5)
      end
    end

    it 'allows for optional page query param' do
      create_list(:merchant, 25)

      get '/api/v1/merchants?page=1'

      expect(response).to be_successful

      page1 = JSON.parse(response.body, symbolize_names: true)

      get '/api/v1/merchants?page=2'

      page2 = JSON.parse(response.body, symbolize_names: true)

      expect(page1.size).to eq(20)
      expect(page2.size).to eq(5)
      expect(page1.pluck(:id)).not_to include(page2.pluck(:id))
    end

    it 'allows the user to pass both per_page and page query params' do
      create_list(:merchant, 10)

      get '/api/v1/merchants?per_page=5&page=2'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants.count).to eq(5)
      expect(merchants.pluck(:id)).to eq(Merchant.last(5).pluck(:id))
    end
  end
end
