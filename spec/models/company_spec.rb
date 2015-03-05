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

    context '#original_names' do

      it 'initially should return an empty array' do
        expect(company.original_names).to match_array([])
      end

      context 'when specified' do
        before do
          @expected_names = ['a','b']
          company[:original_names] = JSON.dump(@expected_names)
        end

        it 'should parse and return the names' do
          expect(company.original_names).to match_array(@expected_names)
        end
      end
    end

    context '#original_names=' do
      it 'should set a name' do
        company.original_names = 'welcome'
        expect(company.original_names).to match_array(['welcome'])
      end

      it 'should reject duplicates' do
        company.original_names = 'panda'
        company.original_names = 'panda'
        expect(company.original_names).to match_array(['panda'])
      end

      it 'should know that original_names is dirty' do
        company.original_names = 'panda'
        expect(company.original_names_changed?).to be(true)
      end
    end
  end

end
