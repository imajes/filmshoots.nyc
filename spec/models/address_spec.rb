require 'rails_helper'

RSpec.describe Address, type: :model do

  let(:address) { FactoryGirl.build_stubbed(:address) }

  it 'should be valid' do
    expect(address).to be_valid
  end

  context 'validations' do
    before do
      @address = FactoryGirl.build(:address, original: '123   N HENRY ST')
      @address.save
    end

    it 'should strip extra spaces' do
      expect(@address.original).to eq('123 N HENRY ST')
    end

    context 'uniqueness of original string' do
      before do
        FactoryGirl.create(:address, original: '123 HUMBOLT ST')
      end

      it 'should not allow a duplicate' do
        dupe = FactoryGirl.build(:address, original: '123 HUMBOLT ST')
        expect(dupe).not_to be_valid
      end

      it 'should not allow a dupe with differing case' do
        dupe = FactoryGirl.build(:address, original: '123 humbolt st')
        expect(dupe).not_to be_valid
      end
    end
  end

  context 'saving geocoded data' do

    before do
      VCR.use_cassette('google_geocode_address') do
        @address = Address.create(original: '370 FORT WASHINGTON AVENUE, Manhattan, NY')
        @address.geocode!
      end
    end

    it 'should set this as geocoded' do
      expect(@address.geocoded).to eq(true)
    end

    it 'should persist the formatted address' do
      expect(@address.formatted).to eq('370 Fort Washington Avenue, New York, NY 10033, USA')
    end

    it 'should preserve the geolocation' do
      expect(@address.longitude).to eq(-73.939317)
      expect(@address.latitude).to eq(40.8474549)
    end

    it 'should persist the neighborhood' do
      expect(@address.neighborhood).to eq('Hudson Heights')
    end

  end

end
