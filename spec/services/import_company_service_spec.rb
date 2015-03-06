require 'rails_helper'

RSpec.describe ImportCompanyService, type: :service do

  context 'single import' do
    before do
      described_class.new('uptown funk').process!
    end

    subject { Company.find_by(name: 'uptown funk') }

    it 'should exist' do
      expect(subject).to be_a_kind_of(Company)
    end
  end

  context 'importing similar duplicate names' do
    before do
      described_class.new('uptown funk').process!
    end

    subject { described_class.new('uptown funk productions').process! }

    it 'should not create a new record' do
      expect { subject }.not_to change { Company.count }
    end

    it 'should add the alternate name' do
      expect { subject }.to change { Company.first.original_names }
    end
  end

  context 'common_name' do
    before do
      @service = described_class.new('uptown funk')
    end

    it 'should downcase the result' do
      expect(@service.common_name('ABC')).to eq('abc')
    end

    it 'should reject noise characters' do
      expect(@service.common_name('abc : def')).to eq('abc def')
    end

    it 'should convert common names' do
      expect(@service.common_name('tv bros.')).to eq('television brothers')
    end

    it 'should reject useless terms' do
      all = 'funk  productions corp. corporation co. company inc. incorporated llc ltd'
      expect(@service.common_name(all)).to eq('funk')
    end

    it 'should trim excess whitespace' do
      expect(@service.common_name('funk   animal  castle')).to eq('funk animal castle')
    end

  end

end
