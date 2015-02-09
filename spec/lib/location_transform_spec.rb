require 'rails_helper'
require 'location_parser'
require 'location_transform'
require 'parslet/rig/rspec'

RSpec.describe LocationTransform, type: :lib do

  let(:permit)    { FactoryGirl.build_stubbed(:permit, :complete_location) }
  let(:parser)    { LocationParser.new }
  let(:transform) { LocationTransform.new }

  location_samples = YAML.load_file(Rails.root.join('spec/locations.yml'))

  context 'a typical location' do

    before do
      @parsed = parser.parse(permit.original_location)
    end

    it 'should transform a typical address' do
      puts 'PARSED'
      ap @parsed
      puts 'TRANSFORMED'
      ap transform.apply(@parsed, permit: permit)


    end

  end

end
