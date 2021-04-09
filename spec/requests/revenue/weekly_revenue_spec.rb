require 'rails_helper'

RSpec.describe 'weekly revenue report' do
  it 'returns a report of all revenue sorted by week' do
    create(:complete_invoice, created_at: "2021-01-07", revenue: 1.0)
    create(:complete_invoice, created_at: "2021-01-14", revenue: 2.0)
    create(:complete_invoice, created_at: "2021-01-21", revenue: 3.0)
    create(:complete_invoice, created_at: "2021-01-28", revenue: 4.0)

    get '/api/v1/revenue/weekly'

    expect(response).to be_successful

    weeks = JSON.parse(response.body, symbolize_names: true)

    expect(weeks).to be_a(Hash)
    check_hash_structure(weeks, :data, Array)
    expect(weeks[:data].count).to eq(4)

    weeks[:data].each do |week|
      expect(week).to be_a(Hash)
      expect(week).to have_key(:id)
      expect(week[:id]).to be_nil
      check_hash_structure(week, :type, String)
      expect(week[:type]).to eq('weekly_revenue')
      check_hash_structure(week, :attributes, Hash)
      check_hash_structure(week[:attributes], :week, String)
      check_hash_structure(week[:attributes], :revenue, Float)
      expect(week.keys).to match_array(%i[id type attributes])
      expect(week[:attributes].keys).to match_array(%i[week revenue])
    end
  end
end
