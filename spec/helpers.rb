module Helpers
  def check_structure(object, key, data_type)
    expect(object).to have_key(key)
    expect(object[key]).to be_a(data_type)
  end
end
