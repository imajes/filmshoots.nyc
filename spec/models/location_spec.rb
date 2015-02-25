require 'rails_helper'

RSpec.describe Location, type: :model do
  before do
    @location = FactoryGirl.create(:location)
  end

  it 'should be valid' do
    expect(@location).to be_valid
  end

  it 'should have an address' do
    expect(@location.address).to be_a_kind_of(Address)
  end

  context 'intersections' do
    subject { @location.intersections.first }

    it 'should have some intersections' do
      expect(subject).to be_a_kind_of(Intersection)
    end

    it 'should track its parent' do
      expect(subject.parent_id).to eq(@location.id)
    end

    it 'should have a depth of 1' do
      expect(subject.depth).to eq(1)
    end
  end
end
