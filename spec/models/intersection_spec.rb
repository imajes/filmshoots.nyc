require 'rails_helper'

RSpec.describe Intersection, type: :model do

  before(:all) do
    @intersection = FactoryGirl.create(:intersection)
    @intersection.streets = [FactoryGirl.create(:street), FactoryGirl.create(:street)]
    @intersection.save
  end

  after(:all) do
    MapType.delete_all
  end

  it "should be valid" do
    expect(@intersection).to be_valid
  end

  it 'should have two cross streets' do
    expect(@intersection.streets.size).to eq(2)
  end

  context 'street' do
    subject { Street.first }

    it "should have the intersection as it's parent" do
      expect(subject.intersection).to eq(@intersection)
    end
  end

end
