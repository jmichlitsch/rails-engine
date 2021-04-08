require 'rails_helper'

RSpec.describe ErrorSerializer do
  it 'accepts errors' do
    serializer = ErrorSerializer.new("Record not found")

    expect(serializer).to be_an(ErrorSerializer)
  end

  it 'produces a hash' do
    error_message = ErrorSerializer.new("Validation failed: Name can't be blank").serialize

    expect(error_message).to be_a(Hash)
    check_hash_structure(error_message, :message, String)
    check_hash_structure(error_message, :error, Array)
    expect(error_message[:error][0]).to be_a(String)
  end
end
