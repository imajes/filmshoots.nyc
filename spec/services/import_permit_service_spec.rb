require 'rails_helper'

RSpec.describe ImportPermitService, type: :service do

  before do
    # # prevent geocode, as it's not relevant here
    # allow_any_instance_of(Address).to receive(:geocode_address).and_return(true)

    @data = {
            "event_id" => "38871",
       "project_title" => "Basketball Wives 4",
          "event_name" => "Washington Park Nov 1",
          "event_type" => "Shooting Permit",
    "event_start_date" => "11/1/11 1:00 AM",
      "event_end_date" => "11/1/11 2:00 PM",
          "entered_on" => "10/31/11 1:43 PM",
            "location" => "Washington Square Park: Washington Square Park  ",
                 "zip" => "10011, ",
                "boro" => "Manhattan",
          "project_id" => "488"
    }

    @service = described_class.new(@data)
  end

  it 'should run the whole stack' do
    expect_any_instance_of(described_class).to receive(:process!).and_return(true)
    described_class.run!(@data)
  end

  it 'should initialize item data' do
    expect(@service.attrs[:zip]).to eq('10011')
    expect(@service.attrs[:boro]).to eq('Manhattan')
    expect(@service.attrs[:event_start]).to eq('2011-11-01 01:00:00.000000000 -0400')
  end

  context 'process!' do

    before do
      class_double(ParseAddressService, :run! => true)
    end

    it 'should process and parse an address' do
      expect(ParseAddressService).to receive(:run!).and_return(true)
      @service.process!
    end

    it 'should create a permit' do
      expect { @service.process! }.to change { Permit.count }.by(1)
    end

  end
end
