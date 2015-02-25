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
      @transformed = transform.apply(@parsed, permit: permit)
    end

    it 'should transform a typical address' do
      expect { transform.apply(@parsed, permit: permit) }.not_to raise_error
    end
  end

  context 'a location' do
    let(:sample) { location_samples['primary_location']['original'] }

    before do
      @parsed = parser.parse(sample)
      @transformed = transform.apply(@parsed, permit: permit)
      @keys = @transformed.map(&:keys).flatten
    end

    it 'should have items' do
      expect(@transformed.size).to eq(9)
    end

    it 'should have 2 locations' do
      expect(@keys.select {|t| t == :location }.size).to eq(2)
    end

    it 'should have 7 intersections' do
      expect(@keys.select { |t| t == :intersection }.size).to eq(7)
    end

    context ':location' do
      subject { @transformed.first[:location] }

      it 'should have valid keys' do
        expect(subject.keys).to match_array([:location_title, :place])
      end

      it 'should strip whitespace from the title' do
        expect(subject[:location_title]).to eq('Monsignor McGolrick Park')
      end

      it 'should convert the place to a clean street' do
        expect(subject[:place]).to eq('Monsignor McGolrick Park, Brooklyn, NY')
      end
    end
  end

  context 'an intersection' do
    let(:sample) { location_samples['streets_and_intersections_only']['original'] }

    before do
      @parsed = parser.parse(sample)
      @transformed = transform.apply(@parsed, permit: permit)
    end

    it 'should have six items' do
      expect(@transformed.size).to eq(6)
    end

    it 'each item should be called :intersection' do
      uniq_keys = @transformed.map(&:keys).flatten.uniq
      expect(uniq_keys.size).to eq(1)
      expect(uniq_keys.first).to eq(:intersection)
    end

    context ':intersection keys' do
      subject { @transformed.first[:intersection] }

      it 'should have valid keys' do
        expect(subject.keys).to match_array([:street, :cross1, :cross2])
      end

      it 'should convert the street to a clean version' do
        expect(subject[:street]).to eq('NORTH HENRY STREET, Brooklyn, NY')
      end

      it 'should convert a cross st to a google friendly place' do
        expect(subject[:cross1]).to eq('NORTH HENRY STREET, Brooklyn, NY at GREENPOINT AVENUE, Brooklyn, NY')
      end
    end
  end
end
