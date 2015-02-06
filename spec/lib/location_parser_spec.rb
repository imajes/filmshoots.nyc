require 'rails_helper'
require 'location_parser'
require 'parslet/rig/rspec'

RSpec.describe LocationParser, type: :lib do

  let(:parser) { LocationParser.new }

  location_samples = YAML.load_file(Rails.root.join('spec/locations.yml'))

  context 'parser rules' do

    context 'simple literals' do

      it ':colon' do
        expect(parser.colon).to parse(':')
      end

      it ':colon?' do
        expect(parser.colon?).to parse(':')
        expect(parser.colon?).to parse('')
      end

      it ':comma' do
        expect(parser.comma).to parse(',')
      end

      it ':comma?' do
        expect(parser.comma?).to parse(',')
        expect(parser.comma?).to parse('')
      end

      it ':space' do
        expect(parser.space).to parse(' ')
      end

      it ':space?' do
        expect(parser.space?).to parse(' ')
        expect(parser.space?).to parse('')
      end

      it ':eof' do
        expect(parser.eof).to parse('')
        expect(parser.eof).to_not parse('a')
      end

    end

    context 'word matches' do
      it ':between' do
        expect(parser.between).to parse('between')
      end

      it ':the_and' do
        expect(parser.the_and).to parse('and')
      end
    end

    context 'matched literals' do

      it ':not_comma' do
        expect(parser.not_comma).to parse('a')
        expect(parser.not_comma).to parse('1')
        expect(parser.not_comma).to parse(' ')
        expect(parser.not_comma).not_to parse(',')
      end

      it ':not_space' do
        expect(parser.not_space).to parse('a')
        expect(parser.not_space).to parse('1')
        expect(parser.not_space).to parse(',')
        expect(parser.not_space).not_to parse(' ')
      end

    end

    context 'delimiter literals' do

      it ':street_delimiter'
      it ':colon_delimiter'
      it ':comma_delimiter'
    end

    context 'street structures' do

      it 'should parse normal streets' do
        expect(parser.street).to parse('1 Monitor Street')
        expect(parser.street).to parse('N HENRY ST')
      end

      it 'should parse a street with an &' do
        expect(parser.street).to parse('Coney Island Beach & Boardwalk', {trace: true})
      end

      it 'should detect words' do
        expect(parser.street_word).to parse('NORTH')
        expect(parser.street_word).to_not parse('NORTH HENRY')
      end
    end

    context 'locations' do
      let(:orig) { location_samples['primary_location']['original'] }
      let(:loc_part) { 'Monsignor McGolrick Park: Monsignor McGolrick Park ,' }

      it 'should match as a location' do
        expect(parser.location).to parse(loc_part, trace: true)
      end

      it 'should match the first part as a street' do
        expect(parser.street).to parse('Monsignor McGolrick Park', trace: true)
      end

      it 'should expand out the ast' do
        expect(parser.shoot_locations).to parse(orig, trace: true)
      end
    end

    context 'intersections' do
      let(:orig) { location_samples['streets_and_intersections_only']['original'] }

      it 'should match a street part' do
        expect(parser.street_delimiter).to parse('between')
        expect(parser.street_delimiter).to parse('and')
        expect(parser.street_delimiter).not_to parse('street')
      end

      it 'should deconstruct an intersection' do
        addr = 'NORTH HENRY STREET between GREENPOINT AVENUE and NORMAN AVENUE'
        expect(parser.intersection).to parse(addr, trace: true)
      end

      it 'should deconstruct an intersection with comma' do
        addr = 'NORTH HENRY STREET between GREENPOINT AVENUE and NORMAN AVENUE, '
        expect(parser.intersection).to parse(addr, trace: true)
      end

      it 'should recognize it as a fragment' do
        addr = 'NORTH HENRY STREET between GREENPOINT AVENUE and NORMAN AVENUE'
        expect(parser.fragment).to parse(addr, trace: true)
      end

      it 'should recognize it as a fragment with comma' do
        addr = 'NORTH HENRY STREET between GREENPOINT AVENUE and NORMAN AVENUE, '
        expect(parser.fragment).to parse(addr, trace: true)
      end

      it 'should expand out the ast' do
        expect(parser.shoot_locations).to parse(orig, trace: true)
      end

    end

    context 'empty parts' do

      it 'should parse a missing part' do
        expect(parser.missing_part).to parse(',', trace: true)
        expect(parser.missing_part).to parse(', ', trace: true)
      end

    end

  end

  RSpec.shared_examples '#parse' do |test, idx|

    it "should parse experiment '#{idx}' accurately" do
      expect(parser).to parse(test, trace: true)
    end
  end

  context 'parser stress test' do

    location_samples[:experiments].each_with_index do |loc, idx|
      it_behaves_like '#parse', loc, idx
    end

  end

end

