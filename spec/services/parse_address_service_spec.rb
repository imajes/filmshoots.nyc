require 'rails_helper'

RSpec.describe ParseAddressService, type: :service do

  before(:all) do
    @permit = FactoryGirl.create(:permit)
  end

  after(:all) do
    @permit.destroy
  end

  context 'normal process' do

    before do
      @service = described_class.new(@permit)
    end

    it 'should initialize the permit' do
      expect(@service.permit).to eq(@permit)
    end

    context 'creating an address' do

      it 'should handle a missing type' do
        expect(@service.create_address(:missing, nil)).to be(false)
      end

      context 'locations' do

        before do
          loc = { location: { location_title: 'Riverside Park', place: 'Promenade Lower – 79th - 95th Streets, Manhattan, NY'}}
          VCR.use_cassette('google_geocode_location') do
            @result = @service.create_address(:location, loc)
          end
        end

        it 'should create a Location' do
          expect(@result).to be_a_kind_of(Location)
        end

        it 'should be attached to the permit as parent' do
          expect(@result.permit).to eq(@permit)
        end

        it 'should save the location title' do
          expect(@result.title).to eq('Riverside Park')
        end

        it 'should create an address' do
          expect(@result.address).to be_a_kind_of(Address)
        end

      end

      context 'plain addresses' do
        before do
          VCR.use_cassette('google_geocode_address') do
            @result = @service.create_address(:address, {address: "370 FORT WASHINGTON AVENUE, Manhattan, NY" })
          end
        end

        it 'should create a Location' do
          expect(@result).to be_a_kind_of(Location)
        end

        it 'should be attached to the permit as parent' do
          expect(@result.permit).to eq(@permit)
        end

        it 'should save the location title' do
          expect(@result.title).to eq('370 FORT WASHINGTON AVENUE, Manhattan, NY')
        end

        it 'should create an address' do
          expect(@result.address).to be_a_kind_of(Address)
        end

      end

      context 'intersections' do
        before do
          intersection = {
            :intersection => {
              :street => "FORT WASHINGTON AVENUE, Manhattan, NY",
              :cross1 => "FORT WASHINGTON AVENUE, Manhattan, NY at WEST 176th STREET, Manhattan, NY",
              :cross2 => "FORT WASHINGTON AVENUE, Manhattan, NY at WEST 177th STREET, Manhattan, NY"
            }
          }

          VCR.use_cassette('google_geocode_intersection') do
            @result = @service.create_address(:intersection, intersection)
          end

          it 'should create an intersection'
          it 'should attach to the permit'
          it 'should create an address'
          it 'should create streets attached to it'
          it 'should not create a title'

        end

      end

      it 'should fail on an unexpected token' do
        expect { @service.create_address(:panda, {}) }.to raise_error
      end

    end
  end

  context 'process!' do
    it 'should present a human readable locations stack' do
      para = ""
      expect(@permit.present_locations).to eq(para)
    end
  end

  context 'forced run'

end
