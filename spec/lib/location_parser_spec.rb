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
        expect(parser.between).to parse('between ')
      end

      it ':the_and' do
        expect(parser.the_and).to parse('and')
        expect(parser.the_and).to parse('and ')
      end
    end

    context 'matched literals' do

      it ':letter' do
        expect(parser.letter).to parse('a')
        expect(parser.letter).to parse('1')
        expect(parser.letter).to parse('*')
        expect(parser.letter).not_to parse(' ')
        expect(parser.letter).not_to parse(':')
        expect(parser.letter).not_to parse(',')
      end

      it ':upper_letter' do
        expect(parser.upper_letter).to parse('A')
        expect(parser.upper_letter).to parse('1')
        expect(parser.upper_letter).to parse(' ')
        expect(parser.upper_letter).not_to parse('a')
        expect(parser.upper_letter).not_to parse(':')
        expect(parser.upper_letter).not_to parse(',')
      end

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

      it ':colon_delimiter' do
        expect(parser.colon_delimiter).to parse(': ')
        expect(parser.colon_delimiter).to parse(':')
        expect(parser.colon_delimiter).to parse(':: ')
        expect(parser.colon_delimiter).to parse('::')
        expect(parser.colon_delimiter).not_to parse(' : : ')
        expect(parser.colon_delimiter).not_to parse(' : ')
      end

      it ':comma_delimiter with comma' do
        expect(parser.comma_delimiter).to parse(',')
        expect(parser.comma_delimiter).to parse(' ,')
        expect(parser.comma_delimiter).to parse(', ')
        expect(parser.comma_delimiter).to parse(' , ')
        expect(parser.comma_delimiter).to_not parse(',:')
      end

      it ':comma_delimiter without comma' do
        expect(parser.comma_delimiter).to parse('')
        expect(parser.comma_delimiter).to parse(':')
        expect(parser.comma_delimiter).to_not parse(' ')
        expect(parser.comma_delimiter).to_not parse('a')
      end

    end

    context 'street structures' do

      context ':street' do
        it 'should parse normal streets' do
          expect(parser.street).to parse('1 Monitor Street')
          expect(parser.street).to parse('N HENRY ST')
        end

        it 'should match locations as a street' do
          expect(parser.street).to parse('Monsignor McGolrick Park')
        end

        it 'should parse a street with an &' do
          expect(parser.street).to parse('Coney Island Beach & Boardwalk')
        end
      end

      context ':street_upper' do
        it 'should parse a typical street' do
          expect(parser.street_upper).to parse('N HENRY ST')
          expect(parser.street_upper).to parse('123 BLEEKER ST')
        end

        it 'should reject lower case places' do
          expect(parser.street_upper).not_to parse('Monsignor McGolrick Park')
          expect(parser.street_upper).not_to parse('1 MONITOR st')
        end

      end
    end

    context 'address types' do
      it 'should parse a plain street, delimited' do
        expect(parser.plain_street).to parse('N HENRY ST,')
        expect(parser.plain_street).to parse('N HENRY ST')
      end

      it 'should handle missing entries' do
        expect(parser.missing_part).to parse(',')
        expect(parser.missing_part).to parse(', ')
        expect(parser.missing_part).not_to parse('abc,')
        expect(parser.missing_part).not_to parse('abc, ')
      end

      context 'locations' do
        let(:orig) { location_samples['primary_location']['original'] }
        let(:loc_part) { 'Monsignor McGolrick Park: Monsignor McGolrick Park ,' }

        it 'should match as a location' do
          expect(parser.location).to parse(loc_part, trace: true)
        end

        it 'should match as a fragment' do
          expect(parser.fragment).to parse(loc_part, trace: true)
        end

        it 'should expand out the ast' do
          expect(parser.shoot_locations).to parse(orig, trace: true)
        end
      end

      context 'intersections' do
        let(:orig) { location_samples['streets_and_intersections_only']['original'] }

        context 'which are valid' do
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

        context 'which are invalid' do
          it 'should not parse an intersection missing between' do
            addr = 'NORTH HENRY STREET GREENPOINT AVENUE and NORMAN AVENUE'
            expect(parser.intersection).not_to parse(addr, trace: true)
          end

          it 'should not parse an intersection missing and' do
            addr = 'NORTH HENRY STREET between GREENPOINT AVENUE NORMAN AVENUE'
            expect(parser.intersection).not_to parse(addr, trace: true)
          end

          it 'should not parse an intersection missing between & and' do
            addr = 'NORTH HENRY STREET GREENPOINT AVENUE NORMAN AVENUE'
            expect(parser.intersection).not_to parse(addr, trace: true)
          end

          it 'should not parse an intersection with & for and' do
            addr = 'NORTH HENRY STREET between GREENPOINT AVENUE & NORMAN AVENUE'
            expect(parser.intersection).not_to parse(addr, trace: true)
          end

          it 'should not parse an intersection with unexpected joining words' do
            addr = 'NORTH HENRY STREET btwn GREENPOINT AVENUE & NORMAN AVENUE'
            expect(parser.intersection).not_to parse(addr, trace: true)
          end
        end

      end

    end

  end

  RSpec.shared_examples '#parse' do |test, idx|

    it "should parse experiment '#{idx}:#{test[0..50]}' accurately" do
      expect(parser).to parse(test, trace: true)
    end
  end

  context 'parser stress test' do

    location_samples[:experiments].each_with_index do |loc, idx|
      it_behaves_like '#parse', loc, idx
    end

  end

end

