require 'rails_helper'

RSpec.describe Company, type: :model do

  let(:company) { FactoryGirl.build_stubbed(:company) }

  context 'basic validity' do
    it 'should be valid' do
      expect(company).to be_valid
    end

    it 'should be searchable' do
      expect(Company).to respond_to(:search)
    end

    context 'original names' do

    end
  end
  context 'creation'
    context 'similar names'

  context 'importing'

end
