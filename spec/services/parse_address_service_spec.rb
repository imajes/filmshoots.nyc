require 'rails_helper'

RSpec.describe ParseAddressService, type: :service do

  before(:all) do
    @permit = FactoryGirl.create(:permit, :complete_location)
  end

  after(:all) do
    @permit.destroy
  end

  before do
    # prevent geocode, as it's not relevant here
    allow_any_instance_of(Address).to receive(:geocode_address).and_return(true)
    @service = described_class.new(@permit)
  end

  context 'initializing' do

    it 'should initialize the permit' do
      expect(@service.permit).to eq(@permit)
    end

    it 'should register force' do
      forced = described_class.new(@permit, true)
      expect(forced.force).to eq(true)
    end
  end

  context 'creating an address' do

    it 'should handle a missing type' do
      expect(@service.create_address(:missing, nil)).to be(false)
    end

    context 'locations' do

      before do
        loc = { location: { location_title: 'Riverside Park', place: 'Promenade Lower – 79th - 95th Streets, Manhattan, NY'}}
        @result = @service.create_address(:location, loc)
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
        @result = @service.create_address(:address, {address: "370 FORT WASHINGTON AVENUE, Manhattan, NY" })
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

        @result = @service.create_address(:intersection, intersection)
      end

      it 'should create an intersection' do
        expect(@result).to be_a_kind_of(Intersection)
      end

      it 'should attach to the permit' do
        expect(@result.permit).to eq(@permit)
      end

      it 'should create an address' do
        expect(@result.address).to be_a_kind_of(Address)
      end

      it 'should create streets attached to it' do
        expect(@result.streets.first).to be_a_kind_of(Street)
      end

      it 'should create the correct number of streets' do
        expect(@result.streets.size).to eq(2)
      end

      it 'should not create a title' do
        expect(@result.title).to be_nil
      end



    end

    it 'should fail on an unexpected token' do
      expect { @service.create_address(:panda, {}) }.to raise_error
    end

  end

  context 'process!' do

    context 'already run' do
      before do
        @permit = FactoryGirl.create(:permit, :complete_location, :with_associated_location)
        @service = described_class.new(@permit)
      end

      it 'when unforced, should not run' do
        expect(@service.process!).to eq(false)
      end

      context 'when forced' do
        let(:forced) { described_class.new(@permit, true) }

        it 'should run' do
          expect(forced).to receive(:parsed_address).and_return([])
          forced.process!
        end
      end
    end

    context 'first run' do
      context 'false original_location' do
        before do
          @permit = FactoryGirl.create(:permit, original_location: nil)
          @logger = double('logger', warn: true)
          @service = described_class.new(@permit)
        end

        it 'should log an error' do
          allow(@service).to receive(:parse_log).and_return(@logger)
          expect(@logger).to receive(:warn)
          @service.process!
        end

        it 'should return false' do
          expect(@service.process!).to eq(false)
        end
      end
    end


    it 'should present a human readable locations stack' do
      para = ""
      expect(@permit.present_locations).to eq(para)
    end
  end

end