require 'rails_helper'

RSpec.describe Category, type: :model do

  let(:category) { FactoryGirl.build_stubbed(:category) }

  it 'is valid' do
    expect(category).to be_valid
  end

end
