require 'rails_helper'

RSpec.describe 'total revenue over a given date range' do
  it 'returns the total revenue across all merchants between dates' do
    create(:complete_invoice, status: 'shipped', created_at: '2012-03-09')

    get '/api/v1/revenue?start=2012-03-09&end=2012-03-11'

    expect(response).to be_successful

    body = JSON.parse(response.body, symbolize_names: true)

    expect(body).to be_a(Hash)
    check_hash_structure(body, :data, Hash)
    expect(body[:data]).to have_key(:id)
    expect(body[:data][:id]).to be_nil
    check_hash_structure(body[:data], :type, String)
    check_hash_structure(body[:data], :attributes, Hash)
    check_hash_structure(body[:data][:attributes], :revenue, Float)
    expect(body[:data][:attributes][:revenue]).to eq(1.0)
    expect(body[:data].keys).to match_array(%i[id type attributes])
    expect(body[:data][:attributes].keys).to match_array(%i[revenue])
  end

  it 'returns an error if the start date is missing' do
    get '/api/v1/revenue?end=2012-03-11'

    expect(response.status).to eq(400)
  end

  it 'returns an error if the end date is missing' do
    get '/api/v1/revenue?start=2012-03-09'

    expect(response.status).to eq(400)
  end

  it 'returns an error if both start and end dates are missing' do
    get '/api/v1/revenue'

    expect(response.status).to eq(400)
  end

  it 'returns an error if the start date is blank' do
    get '/api/v1/revenue?start=&end=2012-03-11'

    expect(response.status).to eq(400)
  end

  it 'returns an error if the end date is blank' do
    get '/api/v1/revenue?start=2012-03-09&end='

    expect(response.status).to eq(400)
  end

  it 'returns an error if both start and end dates are blank' do
    get '/api/v1/revenue?start=&end='

    expect(response.status).to eq(400)
  end

  it 'returns an error if start date is after end date' do
    get '/api/v1/revenue?start=2012-03-12&end=2012-03-11'

    expect(response.status).to eq(400)
  end
end
