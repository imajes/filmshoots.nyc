require 'rails_helper'
require 'location_parser'
require 'parslet/rig/rspec'

RSpec.describe LocationParser, type: :lib do

  let(:parser) { LocationParser.new }

  location_samples = YAML.load_file(Rails.root.join('spec/locations.yml'))

  RSpec.shared_examples '#parse' do |test, locations|

    it "should parse '#{test.humanize}' accurately" do
      expect(parser).to parse(locations['original'], trace: true)
    end

  end

  location_samples.keys.each do |key|
    it_behaves_like '#parse', key, location_samples[key]
  end

  context 'parser rules' do

    context 'simple literals' do

      it 'should consume colons' do
        expect(parser.colon).to parse(':')
      end

      it 'should consume commas' do
        expect(parser.comma).to parse(',')
      end

      it 'should consume spaces' do
        expect(parser.space).to parse(' ')
      end

      it 'should handle space or nothing' do
        expect(parser.space?).to parse(' ')
        expect(parser.space?).to parse('')
      end

      it 'should consume blanks' do
        expect(parser.blank).to parse('')
      end

      it 'should consume punctuation' do
        expect(parser.punct).to parse('&')
      end

      it 'should handle punct or nothing' do
        expect(parser.punct?).to parse('&')
        expect(parser.punct?).to parse('')
      end

    end

    context 'word matches' do
      it 'should match between' do
        expect(parser.between).to parse('between')
      end

      it 'should match and' do
        expect(parser.the_and).to parse('and')
      end
    end

    context 'matched literals' do

      it 'should consume tabs' do
        expect(parser.tab).to parse("\t")
      end

      it 'should consume anything but a comma' do
        expect(parser.not_comma).to parse('a')
        expect(parser.not_comma).to parse('1')
        expect(parser.not_comma).to parse(' ')
        expect(parser.not_comma).not_to parse(',')
      end

      it 'should consume anything but a space' do
        expect(parser.not_space).to parse('a')
        expect(parser.not_space).to parse('1')
        expect(parser.not_space).to parse(',')
        expect(parser.not_space).not_to parse(' ')
      end
    end


    context 'composite literals' do

    end

    context 'grammar structure' do

      it 'should parse normal streets' do
        expect(parser.street).to parse('1 Monitor Street')
        expect(parser.street).to parse('N HENRY ST')
      end

      it 'should parse a street with an &' do
        expect(parser.street).to parse('Coney Island Beach & Boardwalk', {trace: true})
      end

    end

    context 'preparsing' do
      let(:orig) { location_samples['streets_and_intersections_only']['original'] }

      it 'should match a street part' do
        expect(parser.street_delimiter).to parse('between')
        expect(parser.street_delimiter).to parse('and')
        expect(parser.street_delimiter).not_to parse('street')
      end

      it 'should detect words' do
        expect(parser.street_word).to parse('NORTH')
        expect(parser.street_word).to_not parse('NORTH HENRY')
      end

      it 'should split on commas' do
        expect(parser.graf_ast).to parse('ABC, DEF', trace: true)
      end

      it 'should deconstruct an intersection' do
        addr = 'NORTH HENRY STREET between GREENPOINT AVENUE and NORMAN AVENUE'

        expect(parser.intersection).to parse(addr, trace: true)
      end

      it 'should expand out the ast' do
        expect(parser.graf_ast).to parse(orig, trace: true)
      end

    end

    context 'preparse x', focus: true do
      let(:orig) { location_samples['primary_location']['original'] }

      it 'should expand out the ast' do
        expect(parser.graf_ast).to parse(orig, trace: true)
        ap parser.graf_ast.parse(orig)
      end
    end

  end


end

