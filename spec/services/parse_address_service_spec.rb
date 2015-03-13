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
          VCR.use_cassette('google_geocode') do
            @result = @service.create_address(:location, loc)
          end
        end

        subject { @result }

        it 'should create a Location' do
          expect(subject).to be_a_kind_of(Location)
        end
        it 'should be attached to the permit as parent' do
          expect(subject.permit).to eq(@permit)
        end

        it 'should save the location title' do
          expect(subject.title).to eq('Riverside Park')
        end

        it 'should create an address' do
          expect(subject.address).to be_a_kind_of(Address)
        end

      end

      it 'should handle a plain address' do

      end

      it 'should handle an intersection'
      it 'should fail on an unexpected token'

    end



  end

  context 'forced run'

end
