FactoryGirl.define do
  factory :location do
    association :address, formatted: 'Monsignor Mcgolrick Park'

    # after(:build) do |loc|
    #   loc.intersections = [FactoryGirl.build(:intersection)]
    # end
  end
end
