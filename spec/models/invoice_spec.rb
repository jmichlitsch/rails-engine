require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
      it { should belong_to :customer }
      it { should belong_to :merchant }
      it { should have_many(:invoice_items).dependent(:destroy) }
      it { should have_many(:transactions).dependent(:destroy) }
  end
end
