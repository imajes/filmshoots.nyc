require 'rails_helper'

RSpec.describe Permit, type: :model do

  let(:permit) { FactoryGirl.build_stubbed(:permit, :complete_location) }

  it 'should be valid' do
    expect(permit).to be_valid
  end

  context 'scopes' do
    it 'should return permits issued by month'
  end

  context 'mutations' do

    context 'cleaning nulls' do
      before do
        permit.boro = 'NULL'
        permit.zip = 'NULL'
        permit.send(:trim_nulls)
      end

      it 'should fix the boro' do
        expect(permit.boro).to be_nil
      end

      it 'should fix the zip' do
        expect(permit.zip).to be_nil
      end
    end

    it 'should represent all the zips' do
      permit.zip = '10011,10012,10013'
      expect(permit.zips).to match_array(['10011', '10012', '10013'])
    end


    it 'should represent a single zip' do
      permit.zip = '10011'
      expect(permit.zips).to match_array(['10011'])
    end

    it 'should clean extra whitespaces in the original location' do
      permit[:original_location] = 'SEAN   PENN'
      expect(permit.original_location).to eq('SEAN PENN')
    end

    it 'should return the location as a para' do
      para = "\nMonsignor McGolrick Park: Monsignor McGolrick Park\n\tREVIEW AVENUE <> 35 STREET & BORDEN AVENUE\n\tREVIEW AVENUE <> 35 STREET & BORDEN AVENUE\n\tSTARR AVENUE <> VAN DAM STREET & BORDEN AVENUE\n\nSilvercup Studios East: 34-02 Starr Avenue\n\tNORTH HENRY STREET <> NASSAU AVENUE & NORMAN AVENUE\n\tRUSSELL STREET <> NASSAU AVENUE & DRIGGS AVENUE\n\tNASSAU AVENUE <> HUMBOLDT STREET & RUSSELL STREET\n\tRUSSELL STREET <> NASSAU AVENUE & NORMAN AVENUE"
      expect(permit.original_location_as_paragraph).to eq(para)
    end

    context 'formatting addresses' do
      it 'normalizes a street with bldg number' do
        expect(permit.format_address('123 9 STREET')).to eq('123 9th STREET')
      end

      it 'normalizes a street without bldg number' do
        expect(permit.format_address('123 STREET')).to eq('123rd STREET')
      end

      it 'normalizes an avenue with bldg number' do
        expect(permit.format_address('123 9 AVENUE')).to eq('123 9th AVENUE')
      end

      it 'normalizes an avenue without bldg number' do
        expect(permit.format_address('123 AVE')).to eq('123rd AVE')
      end

      it 'ignores unexpected inputs' do
        expect(permit.format_address('123 9 PLACE')).to eq('123 9 PLACE')
      end

      it 'strips leading numbers when requested' do
        expect(permit.format_address('123 9 STREET', true)).to eq('9th STREET')
      end
    end


    context 'cleaning streets' do
      it 'should present a normalized street' do
        expect(permit.clean_street('123 DRIGGS AVENUE')).to eq('123 DRIGGS AVENUE, Brooklyn, NY')
      end

      it 'should present a normalized street with zip' do
        permit.zip = '11222'
        expect(permit.clean_street('123 DRIGGS AVENUE')).to eq('123 DRIGGS AVENUE, Brooklyn, NY 11222')
      end

      it 'should present a normalized intersection' do
        expect(permit.clean_street('123 DRIGGS AVENUE', :intersection)).to eq('DRIGGS AVENUE, Brooklyn, NY')
      end
    end

    it 'returns a google formatted intersection' do
      st = '123 NORTH HENRY STREET'
      cross = '14 DRIGGS AVENUE'
      expect(permit.google_intersection(st, cross)).to eq('NORTH HENRY STREET, Brooklyn, NY at DRIGGS AVENUE, Brooklyn, NY')
    end

  end

  context 'calling the parser' do

    before do
      @parsed = permit.parse_location
    end

    it 'returns a parsed object' do
      expect(@parsed).to be_a_kind_of(Array)
      expect(@parsed.length).to eq(9)
    end

  end

end
