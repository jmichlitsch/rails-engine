require 'rails_helper'

RSpec.describe 'delete an item' do
  it 'deletes an item and returns a 204 with no body' do
    id = create(:item).id

    expect{ delete "/api/v1/items/#{id}" }.to change(Item, :count).by(-1)

    expect(response).to be_successful
    expect(response.status).to eq(204)
    expect(response.body).to be_empty
    expect{ Item.find(id) }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'destroys an invoice if this was the only item on the invoice' do
    item = create(:item)
    invoice = create(:invoice, :with_items, items: [item])

    expect(Item.count).to eq(1)
    expect(Invoice.count).to eq(1)

    delete "/api/v1/items/#{item.id}"
    expect(response).to be_successful
    expect(Item.count).to eq(0)
    expect(Invoice.count).to eq(0)
    expect{ Item.find(item.id) }.to raise_error(ActiveRecord::RecordNotFound)
    expect{ Invoice.find(invoice.id) }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
