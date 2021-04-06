require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'relationships' do
    it { should belong_to :invoice}
  end

  describe 'validations' do
    it { should define_enum_for(:result).with_values([:success, :failed, :refunded])}
  end
end
